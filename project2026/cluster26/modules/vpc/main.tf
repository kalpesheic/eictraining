data "aws_vpc" "main" {
  id = "vpc-0abc7baf500feda6c"
}

# Existing Internet Gateway
data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

# Existing Public Subnet 1
data "aws_subnet" "public_1" {
  filter {
    name   = "cidr-block"
    values = ["192.168.48.0/20"]
  }

  vpc_id = data.aws_vpc.main.id
}

# Existing Public Subnet 2
data "aws_subnet" "public_2" {
  filter {
    name   = "cidr-block"
    values = ["192.168.64.0/20"]
  }

  vpc_id = data.aws_vpc.main.id
}

# Existing Private Subnet 1
data "aws_subnet" "private_1" {
  filter {
    name   = "cidr-block"
    values = ["192.168.0.0/20"]
  }

  vpc_id = data.aws_vpc.main.id
}

# Existing Private Subnet 2
data "aws_subnet" "private_2" {
  filter {
    name   = "cidr-block"
    values = ["192.168.16.0/20"]
  }

  vpc_id = data.aws_vpc.main.id
}