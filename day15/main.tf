resource "aws_vpc" "main" {
	cidr_block           = "10.0.0.0/16"
	enable_dns_hostnames = true
	enable_dns_support   = true

	tags = merge(var.tags, {
		Name             = "${var.environment_name}-vpc"
		Environment      = var.environment_name
		BusinessDivision = var.business_division
	})

	# Optional: add tenancy or instance tenancy if required
	# instance_tenancy = "default"
}