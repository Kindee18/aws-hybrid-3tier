variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
  description = "A private subnet ID for the bastion host"
}

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "common_tags" {
  type = map(string)
}
