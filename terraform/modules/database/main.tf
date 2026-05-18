resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.common_tags
}

resource "aws_db_instance" "main" {
  identifier           = "${var.project_name}-${var.environment}-db"
  allocated_storage    = 20
  storage_type         = "gp3"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  db_name              = "appdb"
  username             = "dbadmin"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.database_sg_id]
  skip_final_snapshot  = true
  multi_az             = var.environment == "prod" ? true : false

  tags = var.common_tags
}
