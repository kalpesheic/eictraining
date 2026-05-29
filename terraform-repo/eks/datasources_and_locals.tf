##############################################
# Locals
##############################################
locals {

  # Business division or team name
  owners = var.business_division

  # Environment name
  environment = var.environment_name

  # Standardized naming prefix
  name = "${local.owners}-${local.environment}"

  # Full EKS cluster name
  eks_cluster_name = "${local.name}-${var.cluster_name}"

}

##############################################
# VPC Data Source
##############################################
data "aws_vpc" "main" {
  id = data.terraform_remote_state.vpc.outputs.vpc_id
}

##############################################
# EKS Cluster Data Source
##############################################
#data "aws_eks_cluster" "main" {
#  name = local.eks_cluster_name
#}
