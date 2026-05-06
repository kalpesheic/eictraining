terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    
  }


 backend "s3" {
    bucket = "kalpesheic042026"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
}
provider "aws" {
  region = var.allowed_region[0]
  #region = var.config1.region
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#resource "aws_vpc" "eicdemo" {
#  cidr_block = "10.0.0.0/16"
#}

data "aws_vpc" "eicdemo" {
  id = "vpc-0e632612fa9de2a0c"
}

data "aws_subnets" "eicdemo" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eicdemo.id]
  }
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = data.aws_vpc.eicdemo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.97.73.251/32"]
  }
}


resource "aws_key_pair" "eicdemo_key" {
  key_name   = "testeic2"
#  public_key = file("testeic2.pub")
public_key = file("/mnt/c/eic2026/testeic2.pub")
 #public_key = file("${path.module}/testeic2.pub")
}

resource "aws_instance" "kalpesh" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.allowed_vm_types[0]
  key_name = aws_key_pair.eicdemo_key.key_name
  subnet_id = data.aws_subnets.eicdemo.ids[0]
  associate_public_ip_address = true
    tags = {
    Name = "docker-kalpesh-demo2"
  }
}








