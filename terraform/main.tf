module "tags" {
  source = "./modules/tags"

  environment = var.environment
  project     = var.project_name
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  db_password  = var.db_password
  common_tags  = module.tags.common_tags
}

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  az_count     = var.az_count
  common_tags  = module.tags.common_tags
}

module "compute" {
  source = "./modules/compute"

  project_name                 = var.project_name
  environment                  = var.environment
  vpc_id                       = module.networking.vpc_id
  public_subnet_ids            = module.networking.public_subnet_ids
  private_subnet_ids           = module.networking.private_subnet_ids
  alb_sg_id                    = module.networking.alb_sg_id
  app_sg_id                    = module.networking.app_sg_id
  instance_type                = var.instance_type
  common_tags                  = module.tags.common_tags
  waf_acl_arn                  = module.networking.waf_acl_arn
  database_password_secret_arn = module.security.secret_arn

  # Environment-specific scaling rules
  asg_min_size         = var.environment == "prod" ? 2 : 1
  asg_desired_capacity = var.environment == "prod" ? 2 : 1
  asg_max_size         = var.environment == "prod" ? 4 : 2
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

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  bastion_subnet_id  = module.networking.private_subnet_ids[0] # Bastion in first AZ
  private_subnet_ids = var.environment == "prod" ? module.networking.private_subnet_ids : [module.networking.private_subnet_ids[0]]
  common_tags        = module.tags.common_tags
  app_sg_id          = module.networking.app_sg_id
}

module "observability" {
  source = "./modules/observability"

  project_name        = var.project_name
  environment         = var.environment
  alb_arn_suffix      = module.compute.alb_arn_suffix
  db_instance_id      = module.database.db_instance_id
  asg_name            = module.compute.blue_asg_name # Defaulting to blue
  rollback_lambda_arn = module.compute.rollback_lambda_arn
  common_tags         = module.tags.common_tags
}

module "governance" {
  source = "./modules/governance"
  count  = var.environment == "prod" ? 1 : 0

  project_name = var.project_name
  environment  = var.environment
  common_tags  = module.tags.common_tags
}
