
module "vpc" {
  source = "./modules/vpc"
  owner        = var.owner
  department = var.department
  project_name = var.project_name
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id         = module.vpc.vpc_id
  allowed_ssh_ip = var.allowed_ssh_ip

  owner        = var.owner
  department   = var.department
  project_name = var.project_name
}


module "ec2" {
  source = "./modules/ec2"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.sg_id
  key_name          = var.key_name
  owner        = var.owner
  department   = var.department
  project_name = var.project_name
  
}