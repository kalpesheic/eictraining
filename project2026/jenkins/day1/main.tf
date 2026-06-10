data "aws_vpc" "existing" {

id = "vpc-02358ddc1cb955bcd"
}

# Internet Gateway
#resource "aws_internet_gateway" "igw" {
#  vpc_id = data.aws_vpc.existing.id

 # tags = {
 #   Name = "existing-vpc-igw"
 # }
#}
data "aws_internet_gateway" "existing_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = "10.0.13.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-sub-kalpesh"
  }
}
# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = data.aws_vpc.existing.id
  cidr_block        = "10.0.113.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-sub-kalpesh"
  }
}
# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.existing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.existing_igw.id
  }

tags = {
  Name = "public-rt-kalpesh"
}
}
# Private Route Table
  
resource "aws_route_table" "private_rt" {
vpc_id = data.aws_vpc.existing.id 
tags = {
  Name = "private-rt-kalpesh"
}
}

# route table assocation

resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public_subnet.id 
  route_table_id = aws_route_table.public_rt.id  
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "ec2_sg" {
  name = "ssh-access"
  vpc_id = data.aws_vpc.existing.id
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.aes_tags 

}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "kalpesh-poc" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = file("${path.module}/jenkins.sh")

    tags = merge(
     var.aes_tags,
    {
    Name = "kalpesh-ec2" 
}
    )
}
