provider "aws" {
  region = var.aws_region

  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    apigateway     = "http://127.0.0.1:4566"
    apigatewayv2   = "http://127.0.0.1:4566"
    autoscaling    = "http://127.0.0.1:4566"
    cloudfront     = "http://127.0.0.1:4566"
    cloudwatch     = "http://127.0.0.1:4566"
    cloudwatchlogs = "http://127.0.0.1:4566"
    ec2            = "http://127.0.0.1:4566"
    elbv2          = "http://127.0.0.1:4566"
    iam            = "http://127.0.0.1:4566"
    lambda         = "http://127.0.0.1:4566"
    logs           = "http://127.0.0.1:4566"
    rds            = "http://127.0.0.1:4566"
    route53        = "http://127.0.0.1:4566"
    s3             = "http://127.0.0.1:4566"
    secretsmanager = "http://127.0.0.1:4566"
    ses            = "http://127.0.0.1:4566"
    sns            = "http://127.0.0.1:4566"
    sqs            = "http://127.0.0.1:4566"
    ssm            = "http://127.0.0.1:4566"
    sts            = "http://127.0.0.1:4566"
    waf            = "http://127.0.0.1:4566"
    wafv2          = "http://127.0.0.1:4566"
  }
}
