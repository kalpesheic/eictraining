output "instance_public_ip" {
  value = module.ec2.public_ip
}

output "ssh_command" {
  value = "ssh -i Ekansh-bootcamp.pem ec2-user@${module.ec2.public_ip}"
}