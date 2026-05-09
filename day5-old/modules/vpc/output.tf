output "vpc_id" {
  value       = data.aws_vpc.main.id
  description = "Existing VPC ID"
}

output "public_subnet_ids" {
  value       = [aws_subnet.public.id]
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = [aws_subnet.private.id]
  description = "Private subnet IDs"
}

output "public_subnet_map" {
  value = {
    public = aws_subnet.public.id
  }
  description = "Public subnet mapping"
}

output "internet_gateway_id" {
  value       = data.aws_internet_gateway.igw.id
  description = "Internet Gateway ID attached to the VPC"
}