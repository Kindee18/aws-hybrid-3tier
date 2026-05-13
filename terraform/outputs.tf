output "alb_dns_name" {
  value = module.compute.alb_dns_name
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
}

output "lambda_invoke_url" {
  value = module.serverless.lambda_invoke_url
}

output "cloudfront_domain" {
  value = module.storage.cloudfront_domain
}

output "s3_bucket_name" {
  value = module.storage.s3_bucket_name
}

output "vpc_id" {
  value = module.networking.vpc_id
}
