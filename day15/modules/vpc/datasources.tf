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

# Existing Internet Gateway
data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

# Existing Public Subnet
data "aws_subnet" "public" {
  filter {
    name   = "cidr-block"
    values = ["10.0.13.0/24"]
  }

  vpc_id = data.aws_vpc.main.id
}

# Existing Private Subnet 1
data "aws_subnet" "private_1" {
  filter {
    name   = "cidr-block"
    values = ["10.0.113.0/24"]
  }

  vpc_id = data.aws_vpc.main.id
}

# Existing Private Subnet 2
data "aws_subnet" "private_2" {
  filter {
    name   = "cidr-block"
    values = ["10.0.123.0/24"]
  }

  vpc_id = data.aws_vpc.main.id
}