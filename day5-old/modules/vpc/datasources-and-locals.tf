# Datasources
#data "aws_availability_zones" "available" {
#  state = "available"
#}

# Locals Block
#locals {
  #azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  #public_subnets  = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)]
 # private_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 10)]
#}

data "aws_vpc" "main" {
  id = "vpc-02358ddc1cb955bcd"
}

data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.main.id]
  }
}