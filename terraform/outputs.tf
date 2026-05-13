output "alb_dns_name" {
  value       = module.compute.alb_dns_name
  description = "DNS name of the Application Load Balancer"
}

output "rds_endpoint" {
  value       = module.database.rds_endpoint
  description = "RDS PostgreSQL endpoint"
  sensitive   = true
}

output "lambda_invoke_url" {
  value       = module.serverless.lambda_invoke_url
  description = "Lambda invoke URL"
}

output "cloudfront_domain" {
  value       = module.storage.cloudfront_domain
  description = "CloudFront distribution domain"
}

output "s3_bucket_name" {
  value       = module.storage.s3_bucket_name
  description = "S3 bucket name"
}

output "vpc_id" {
  value       = module.networking.vpc_id
  description = "VPC ID"
}

output "private_subnet_ids" {
  value       = module.networking.private_subnet_ids
  description = "Private subnet IDs"
}

output "alb_sg_id" {
  value       = module.networking.alb_sg_id
  description = "ALB Security Group ID"
}

output "app_sg_id" {
  value       = module.networking.app_sg_id
  description = "App Security Group ID"
}

output "database_sg_id" {
  value       = module.networking.database_sg_id
  description = "Database Security Group ID"
}

output "database_subnet_ids" {
  value       = module.networking.database_subnet_ids
  description = "Database subnet IDs"
}
