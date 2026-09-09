
# Provider
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}



# Get Default VPC

data "aws_vpc" "default" {
  default = true
}

# ECS Module
# --------------------------------------------------

module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name

  vpc_id = data.aws_vpc.default.id

  ecs_subnet_ids = var.ecs_subnet_ids

  ecs_security_group_id = var.ecs_security_group_id

  container_image = var.container_image

  container_port = var.container_port

  desired_count = var.desired_count

  cpu = var.ecs_cpu

  memory = var.ecs_memory
}

# --------------------------------------------------
# ALB Module
# --------------------------------------------------

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name

  vpc_id = data.aws_vpc.default.id

  alb_subnet_ids = var.alb_subnet_ids

  alb_security_group_id = var.alb_security_group_id

  container_port = var.container_port
}

# --------------------------------------------------
# CloudFront Module
# --------------------------------------------------

module "cloudfront" {
  source = "./modules/cloudfront"

  project_name = var.project_name

  alb_dns_name = module.alb.alb_dns_name
}
