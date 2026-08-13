
# Provider
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}



# Get Default VPC

data "aws_vpc" "default" {
  default = true
}


# Get Default VPC Subnets

data "aws_subnet" "rds_a" {
  id ="subnet-0301286d78d3e4824"
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
    filter {
    name   = "availability-zone"
    values = ["ap-south-1a"]
  }
}

data "aws_subnet" "rds_b" {
  id = "subnet-061beab7f94c08acb"
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
    filter {
    name   = "availability-zone"
    values = ["ap-south-1b"]
  }
}


# DB Subnet Group

resource "aws_db_subnet_group" "default" {
  name = "kalpesh-default-vpc-rds"

  subnet_ids = [
    data.aws_subnet.rds_a.id,
    data.aws_subnet.rds_b.id
  ]

  tags = {
    Name        = "kalpesh-postgres"
    Email_ID    = "Kalpesh.kumar@einfochips.com"
    Department  = "PES"
    BU          = "IA"
    END_Date    = "31-08-2026"
    Environment = "dev"
    Project     = "secret-rotation"
  }
}


# RDS Security Group

resource "aws_security_group" "rds" {
  name        = "kalpesh-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "PostgreSQL from default VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
     Name        = "kalpesh-postgres"
    Email_ID    = "Kalpesh.kumar@einfochips.com"
    Department  = "PES"
    BU          = "IA"
    END_Date    = "31-08-2026"
    Environment = "dev"
    Project     = "secret-rotation"
  }
}


# RDS PostgreSQL

resource "aws_db_instance" "postgres" {
  identifier = "kalpesh-postgres"

  engine         = "postgres"
  engine_version = "17"

  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "appdb"
  username = "kalpeshadmin"

  # AWS manages the master password in Secrets Manager
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 1

  skip_final_snapshot = true

  deletion_protection = false

  tags = {
    Name        = "kalpesh-postgres"
    Email_ID    = "Kalpesh.kumar@einfochips.com"
    Department  = "PES"
    BU          = "IA"
    END_Date    = "31-08-2026"
    Environment = "dev"
    Project     = "secret-rotation"
  }
}

