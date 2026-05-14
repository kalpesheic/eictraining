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