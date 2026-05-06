output "vpc_id" {
  value = aws_vpc.Ekansh_vpc_bootcamp.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}