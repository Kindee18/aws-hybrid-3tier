provider "aws" {
  region = var.aws_region

  # Allow local testing/mocking
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  default_tags {
    tags = module.tags.common_tags
  }
}
