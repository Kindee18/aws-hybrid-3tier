output "cloudfront_domain" {
  value = length(aws_cloudfront_distribution.main) > 0 ? aws_cloudfront_distribution.main[0].domain_name : "disabled-in-dev"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.main.id
}
