output "vpc_id" {
  description = "Existing VPC ID"
  value       = data.aws_vpc.main.id
}

output "internet_gateway_id" {
  description = "Existing Internet Gateway ID"
  value       = data.aws_internet_gateway.igw.id
}

output "public_subnet_ids" {
  description = "Existing public subnet IDs"
  value = [
    data.aws_subnet.public_1.id,
    data.aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  description = "Existing private subnet IDs"
  value = [
    data.aws_subnet.private_1.id,
    data.aws_subnet.private_2.id
  ]
}

output "public_subnet_map" {
  description = "Public subnet mapping"
  value = {
    public_1 = data.aws_subnet.public_1.id
    public_2 = data.aws_subnet.public_2.id
  }
}