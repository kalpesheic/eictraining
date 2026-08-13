# Created VPCs without IGW
# VPC 1

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

# ------------------------------------------------------------
# VPC 1 - Public Subnet
# ------------------------------------------------------------

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

# ------------------------------------------------------------
# VPC 1 - Private Subnet
# ------------------------------------------------------------

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

# ------------------------------------------------------------
# VPC 1 - Public Route Table
# ------------------------------------------------------------

resource "aws_route_table" "vpc_1_public_rt" {
  vpc_id = aws_vpc.vpc_1.id

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc-1-public-rt"
    }
  )
}

# ------------------------------------------------------------
# VPC 1 - Private Route Table
# ------------------------------------------------------------

resource "aws_route_table" "vpc_1_private_rt" {
  vpc_id = aws_vpc.vpc_1.id

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc-1-private-rt"
    }
  )
}

# ------------------------------------------------------------
# VPC 1 - Route Table Associations
# ------------------------------------------------------------

resource "aws_route_table_association" "vpc_1_public_assoc" {
  subnet_id      = aws_subnet.vpc_1_public_subnet.id
  route_table_id = aws_route_table.vpc_1_public_rt.id
}

resource "aws_route_table_association" "vpc_1_private_assoc" {
  subnet_id      = aws_subnet.vpc_1_private_subnet.id
  route_table_id = aws_route_table.vpc_1_private_rt.id
}


# ============================================================
# VPC 2
# ============================================================

resource "aws_vpc" "vpc_2" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc-2"
    }
  )
}

# VPC Peering related configuration
# ------------------------------------------------------------
# VPC 2 - Private Route Table
# ------------------------------------------------------------

resource "aws_route_table" "vpc_2_private_rt" {
  vpc_id = aws_vpc.vpc_2.id

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc-2-private-rt"
    }
  )
}
# ============================================================
# VPC PEERING
# VPC-1 Private Subnet <--> VPC-2 Private Subnet
# ============================================================

resource "aws_vpc_peering_connection" "vpc1_to_vpc2" {
  vpc_id      = aws_vpc.vpc_1.id
  peer_vpc_id = aws_vpc.vpc_2.id
  auto_accept = true

  tags = merge(
    var.aes_tags,
    {
      Name = "kalpesh-vpc1-to-vpc2-peering"
    }
  )
}


# ------------------------------------------------------------
# VPC-1 Private Route Table
# Allow VPC-1 private subnet to reach VPC-2
# ------------------------------------------------------------

resource "aws_route" "vpc1_to_vpc2" {
  route_table_id            = aws_route_table.vpc_1_private_rt.id
  destination_cidr_block    = aws_vpc.vpc_2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
}


# ------------------------------------------------------------
# VPC-2 Private Route Table
# Allow VPC-2 private subnet to reach VPC-1
# ------------------------------------------------------------

resource "aws_route" "vpc2_to_vpc1" {
  route_table_id            = aws_route_table.vpc_2_private_rt.id
  destination_cidr_block    = aws_vpc.vpc_1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
}