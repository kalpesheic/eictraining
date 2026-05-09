resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.environment_name}-public-rt"
  })
}

resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.main.id

  #route {
  #  cidr_block = "0.0.0.0/0"
    # NAT gateway assumed to exist if needed
 #   nat_gateway_id = aws_nat_gateway.nat.id
 # }

  tags = merge(var.tags, {
    Name = "${var.environment_name}-private-rt"
  })
}

# Create subnets

resource "aws_subnet" "public" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = "10.0.13.0/24"

  tags = merge(var.tags, {
    Name = "${var.environment_name}-public-subnet"
  })
}

resource "aws_subnet" "private" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = "10.0.113.0/24"

  tags = merge(
     {
    Name = "${var.environment_name}-private-subnet"
     },
    var.tags
  )
}

#route associations

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}