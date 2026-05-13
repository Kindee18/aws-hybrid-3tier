terraform {
  backend "s3" {
    bucket         = "terraform-state-hybrid-3tier-${var.environment}"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-hybrid-3tier"
    encrypt        = true
  }
}
