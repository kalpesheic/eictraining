data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "kalpesheic042026"
    key    = "dev/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}



output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id

}
output "private_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

output "public_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}


#output "eks_cluster_name" {
#  value = aws_eks_cluster.main.name
#}

#output "eks_cluster_security_group_id" {
#  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
#}

