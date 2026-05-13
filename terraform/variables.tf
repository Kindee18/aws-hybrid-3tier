variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
    error_message = "Allowed regions: us-east-1, us-west-2, eu-west-1."
  }
}

variable "project_name" {
  description = "Project name for tagging and naming"
  type        = string
  default     = "hybrid-3tier"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
