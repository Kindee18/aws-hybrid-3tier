variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "alb_arn_suffix" {
  type        = string
  description = "The ARN suffix of the ALB (for CloudWatch metrics)"
}

variable "db_instance_id" {
  type        = string
  description = "The RDS instance identifier"
}

variable "asg_name" {
  type        = string
  description = "The name of the Auto Scaling Group"
}

variable "common_tags" {
  type = map(string)
}
