output "ec2_public_ip" {
  value = aws_instance.bootcamp_kalpesh.public_ip
}