resource "aws_lb" "main" {
  name                       = "${var.project_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg_id]
  subnets                    = var.public_subnet_ids
  drop_invalid_header_fields = true

  tags = var.common_tags
}

resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = aws_lb.main.arn
  web_acl_arn  = var.waf_acl_arn
}

# Target Group - BLUE
resource "aws_lb_target_group" "blue" {
  name        = "${var.project_name}-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.common_tags, { Tier = "Blue" })
}

# Target Group - GREEN
resource "aws_lb_target_group" "green" {
  name        = "${var.project_name}-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.common_tags, { Tier = "Green" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = 100 # Change weights for Blue/Green or Canary
      }
      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = 0
      }
      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_launch_template" "main" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  # Spot Instance Optimization for Non-Prod
  instance_market_options {
    market_type = var.environment == "prod" ? null : "spot"
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.app_sg_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3 python3-pip
              pip3 install flask
              cat << 'APP' > /home/ec2-user/app.py
              from flask import Flask
              app = Flask(__name__)
              @app.route('/')
              def home(): return 'Hybrid 3-Tier App Running!'
              @app.route('/health')
              def health(): return 'OK'
              if __name__ == '__main__':
                  app.run(host='0.0.0.0', port=80)
              APP
              python3 /home/ec2-user/app.py &
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = var.common_tags
  }

  tags = var.common_tags
}

# ASG - BLUE
resource "aws_autoscaling_group" "blue" {
  name                = "${var.project_name}-asg-blue"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.blue.arn]
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-blue"
    propagate_at_launch = true
  }
}

# ASG - GREEN
resource "aws_autoscaling_group" "green" {
  name                = "${var.project_name}-asg-green"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.green.arn]
  min_size            = 0 # Green can be 0 when not deploying
  max_size            = 4
  desired_capacity    = 0

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-green"
    propagate_at_launch = true
  }
}
