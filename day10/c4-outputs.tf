output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID used by EKS and other services"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnets for EKS worker nodes"
}


output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Public subnets for ALB, NLB, etc."
}

output "public_subnet_map" {
  value       = module.vpc.public_subnet_map
  description = "Public subnets for ALB, NLB, etc."
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "eks_cluster_id" {
  value = module.eks.eks_cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks.eks_cluster_certificate_authority_data
}

