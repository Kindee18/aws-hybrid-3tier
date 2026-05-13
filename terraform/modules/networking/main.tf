resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "${var.environment}-vpc" }
}

# Add subnets, IGW, NAT etc. (simplified for demo)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
output "vpc_id" { value = aws_vpc.main.id }
output "public_subnets" { value = [] }
output "private_subnets" { value = [] }
