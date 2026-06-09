locals {

    owners = var.business_division  # Example: "retail"
    environment = var.environment_name  # Example: "dev"

  eks_cluster_name = "${var.environment_name}-${var.cluster_name}"
   # Standardized naming prefix: "<division>-<env>"
  name = "${local.owners}-${local.environment}"  # Example: "retail-dev"
}
