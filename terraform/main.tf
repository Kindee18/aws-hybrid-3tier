module "tags" {
  source = "./modules/tags"

  environment = var.environment
  project     = var.project_name
}

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  common_tags  = module.tags.common_tags
}

module "compute" {
  source = "./modules/compute"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  alb_sg_id          = module.networking.alb_sg_id
  app_sg_id          = module.networking.app_sg_id
  instance_type      = var.instance_type
  common_tags        = module.tags.common_tags
}

module "database" {
  source = "./modules/database"

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.networking.vpc_id
  subnet_ids     = module.networking.database_subnet_ids
  database_sg_id = module.networking.database_sg_id
  db_password    = var.db_password
  common_tags    = module.tags.common_tags
}

module "serverless" {
  source = "./modules/serverless"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = module.tags.common_tags
}

module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = module.tags.common_tags
}

module "management" {
  source = "./modules/management"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  subnet_id    = module.networking.private_subnet_ids[0] # Place in the first private subnet
  common_tags  = module.tags.common_tags
}

module "observability" {
  source = "./modules/observability"

  project_name   = var.project_name
  environment    = var.environment
  alb_arn_suffix = module.compute.alb_arn_suffix
  db_instance_id = module.database.db_instance_id
  asg_name       = module.compute.asg_name
  common_tags    = module.tags.common_tags
}
