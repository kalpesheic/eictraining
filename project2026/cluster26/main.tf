module "vpc" {
  source           = "./modules/vpc"
  environment_name = var.environment_name
  tags             = var.tags
}

module "eks" {
  source                          = "./modules/eks"
  vpc_id                          = module.vpc.vpc_id
  private_subnet_ids              = module.vpc.private_subnet_ids
  public_subnet_ids               = module.vpc.public_subnet_ids
  environment_name                = var.environment_name
  aws_region                      = var.aws_region
  business_division               = var.business_division
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_service_ipv4_cidr       = var.cluster_service_ipv4_cidr
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  node_instance_types             = var.node_instance_types
  node_capacity_type              = var.node_capacity_type
  node_disk_size                  = var.node_disk_size
  istio_enabled                   = var.istio_enabled
  tags                            = var.tags
}
