module "tags" {
  source = "./modules/tags"

  environment = var.environment
  project     = var.project_name
}

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = "10.0.0.0/16"
}

module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.private_subnet_ids
  alb_sg_id    = module.networking.alb_sg_id
  app_sg_id    = module.networking.app_sg_id
  instance_type = var.instance_type
}

module "database" {
  source = "./modules/database"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.database_subnet_ids
  app_sg_id    = module.networking.app_sg_id
}

module "serverless" {
  source = "./modules/serverless"

  project_name = var.project_name
  environment  = var.environment
}

module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
  environment  = var.environment
}
