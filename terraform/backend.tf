terraform {
  backend "s3" {
    bucket         = "${var.project_name}-terraform-state-${var.aws_region}"
    key            = "${terraform.workspace}/terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
    use_lockfile   = true
  }
}
