# Simplified EC2 ASG + ALB
# (Full implementation would include launch template, ASG, ALB, etc.)
resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
}
output "alb_dns" { value = "alb-demo.example.com" }
