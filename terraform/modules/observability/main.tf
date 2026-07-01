data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      # --- ROW 1: ALB Performance ---
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix, { color = "#2ca02c" }],
            [".", "HTTPCode_Target_5XX_Count", ".", ".", { color = "#d62728" }]
          ]
          period = 300
          stat   = "Sum"
          region = data.aws_region.current.region
          title  = "ALB Traffic & Errors"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix, { stat = "Average", color = "#1f77b4" }],
            ["...", { stat = "p99", color = "#9467bd" }]
          ]
          period = 300
          region = data.aws_region.current.region
          title  = "ALB Latency (Avg & P99)"
        }
      },
      # --- ROW 2: Compute (ASG) ---
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", var.asg_name],
            [".", "GroupInServiceInstances", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.region
          title  = "ASG Instance Counts"
        }
      },
      # --- ROW 3: Database (RDS) ---
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance_id, { color = "#ff7f0e" }]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.region
          title  = "RDS CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.db_instance_id, { color = "#17becf" }]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.region
          title  = "RDS Connections"
        }
      }
    ]
  })
}
