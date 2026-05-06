resource "aws_security_group" "Ekansh_sg_bootcamp" {
  name        = "secure-sg"
  description = "Restricted SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "secure-sg"
    Owner       = var.owner
    Department  = var.department
    ProjectName = var.project_name
    
  }
}