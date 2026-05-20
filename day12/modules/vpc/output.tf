output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [data.aws_subnet.public.id]
}

output "private_subnet_ids" {
  value = [
    data.aws_subnet.private_1.id,
    data.aws_subnet.private_2.id
  ]
}

output "public_subnet_map" {
  value = {
    public = data.aws_subnet.public.id
  }
}

output "internet_gateway_id" {
  value = data.aws_internet_gateway.igw.id
}