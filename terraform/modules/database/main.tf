resource "aws_db_instance" "postgres" {
  allocated_storage = 20
  engine = "postgres"
  instance_class = "db.t3.micro"
  # username/password via variables in production
  tags = { Name = "${var.environment}-rds" }
}
output "rds_endpoint" { value = aws_db_instance.postgres.endpoint }
