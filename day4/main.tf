
# VPC 1
# Created without Internet Gateway

resource "aws_vpc" "vpc_1" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc-1"
    }
  )
}

# VPC 1 - Public Subnet

resource "aws_subnet" "vpc_1_public_subnet" {
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc-1-public-subnet"
      Type = "Public"
    }
  )
}

# VPC 1 - Private Subnet

resource "aws_subnet" "vpc_1_private_subnet" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "ap-south-1a"

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc-1-private-subnet"
      Type = "Private"
    }
  )
}


# VPC 1 - Public Route Table

resource "aws_route_table" "vpc_1_public_rt" {
  vpc_id = aws_vpc.vpc_1.id

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc-1-public-rt"
    }
  )
}

# ============================================================
# VPC 1 - Private Route Table
# ============================================================

resource "aws_route_table" "vpc_1_private_rt" {
  vpc_id = aws_vpc.vpc_1.id

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc-1-private-rt"
    }
  )
}


# ============================================================
# VPC 1 - Public Subnet Route Table Association
# ============================================================

resource "aws_route_table_association" "vpc_1_public_assoc" {
  subnet_id      = aws_subnet.vpc_1_public_subnet.id
  route_table_id = aws_route_table.vpc_1_public_rt.id
}


# ============================================================
# VPC 1 - Private Subnet Route Table Association
# ============================================================

resource "aws_route_table_association" "vpc_1_private_assoc" {
  subnet_id      = aws_subnet.vpc_1_private_subnet.id
  route_table_id = aws_route_table.vpc_1_private_rt.id
}

