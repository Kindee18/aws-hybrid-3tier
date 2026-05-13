resource "aws_db_instance" "main" {
  # full RDS PostgreSQL multi-AZ
  allocated_storage = 20
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  # multi_az = true
  # etc.
}
