terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Backend is configured in backend.tf

module "networking" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  environment = var.environment
}

module "compute" {
  source = "./modules/compute"
  vpc_id = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  environment = var.environment
}

module "database" {
  source = "./modules/database"
  vpc_id = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  environment = var.environment
}

module "serverless" {
  source = "./modules/serverless"
  environment = var.environment
}

module "storage" {
  source = "./modules/storage"
  environment = var.environment
}

output "alb_dns" {
  value = module.compute.alb_dns
}
