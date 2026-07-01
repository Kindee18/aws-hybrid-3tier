resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.project_name}-db-password-${var.environment}"
  description             = "Database master password"
  recovery_window_in_days = 0 # Force delete for demo purposes

  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

output "secret_arn" {
  value = aws_secretsmanager_secret.db_password.arn
}
