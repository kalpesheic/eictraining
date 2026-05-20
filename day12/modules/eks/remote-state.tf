data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "kalpesheic042026"
    key    = "dev/terraform.tfstate"
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


