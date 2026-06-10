module "vpc" {
  source           = "./modules/vpc"
  environment_name = var.environment_name
  tags             = var.tags
}

module "eks" {
  source           = "./modules/eks"
  environment_name = var.environment_name
  tags             = var.tags
}
