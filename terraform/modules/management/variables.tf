variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "bastion_subnet_id" {
  type        = string
  description = "A private subnet ID for the bastion host placement"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of private subnet IDs where VPC Endpoints should span"
}

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "common_tags" {
  type = map(string)
}

variable "app_sg_id" {
  type        = string
  description = "The security group ID of the application instances."
}

