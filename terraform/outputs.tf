output "alb_dns_name" {
  value = module.compute.alb_dns
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
}
