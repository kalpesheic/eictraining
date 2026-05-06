data "aws_ami" "al2023" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_instance" "ekansh-ec2bootcamp" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.medium"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = file("${path.module}/userdata.sh")

  root_block_device {
    encrypted   = true
    volume_size = 30
    volume_type = "gp3"
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Owner       = var.owner
    Department  = var.department
    ProjectName = var.project_name

  }
}