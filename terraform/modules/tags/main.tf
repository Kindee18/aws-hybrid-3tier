resource "null_resource" "tags" {}

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = "Kindee18"
    ManagedBy   = "Terraform"
  }
}

output "common_tags" {
  value = local.common_tags
}
