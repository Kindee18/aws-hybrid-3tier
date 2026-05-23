resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.common_tags
}

resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${var.project_name}-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  engine_version          = "15.4"
  database_name           = "appdb"
  master_username         = "dbadmin"
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [var.database_sg_id]
  skip_final_snapshot     = true
  storage_encrypted       = true
  deletion_protection     = var.environment == "prod" ? true : false

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5 # Lowest possible for Aurora Serverless v2
  }

  tags = var.common_tags
}

resource "aws_rds_cluster_instance" "main" {
  count               = var.environment == "prod" ? 2 : 1
  identifier          = "${var.project_name}-db-${count.index}"
  cluster_identifier  = aws_rds_cluster.main.id
  instance_class      = "db.serverless"
  engine              = aws_rds_cluster.main.engine
  engine_version      = aws_rds_cluster.main.engine_version
  db_subnet_group_name = aws_db_subnet_group.main.name

  tags = var.common_tags
}
