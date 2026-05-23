output "rds_endpoint" {
  value = aws_rds_cluster.main.endpoint
}

output "db_instance_id" {
  value = aws_rds_cluster.main.cluster_identifier
}
