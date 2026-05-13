resource "aws_s3_bucket" "assets" {
  bucket = "${var.environment}-assets-hybrid-3tier"
}
