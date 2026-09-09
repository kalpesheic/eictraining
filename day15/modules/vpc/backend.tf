terraform {
  backend "s3" {
    bucket = "kalpesheic042026"
    key    = "dev/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}