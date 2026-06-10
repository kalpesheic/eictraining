module "vpc" {
  source           = "./modules/vpc"
  environment_name = var.environment_name
  tags             = var.tags
}
module "eks" {
  source             = "./modules/eks"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  environment_name   = var.environment_name
  tags               = var.tags
}
