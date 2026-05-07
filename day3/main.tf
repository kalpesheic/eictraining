locals {
  vpc_id              = "vpc-02358ddc1cb955bcd"
  vpc_cidr            = "10.0.0.0/16"
  internet_gateway_id = "igw-095a43d99a5ec72d6"
  nat_gateway_id      = "nat-054be5efc41467fef"
  public_subnet_ids = ["subnet-0c1d51bdec6bbfc49"]
route_table_id = "rtb-0898c89baeb6ebb57"
}


resource "aws_security_group" "ec2_sg" {
  name = "ssh-access"
  vpc_id = local.vpc_id
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

resource "aws_instance" "bootcamp_kalpesh" {
  ami = "ami-0f58b397bc5c1f2e8" 
  instance_type = "t2.micro"
  subnet_id = local.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name = "kalpesh2026"
  tags = var.aes_tags 
}