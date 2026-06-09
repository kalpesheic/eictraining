 
 terraform {
   
 backend "s3" {
    bucket = "kalpesheic042026"
    key    = "dev/ec2/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
 }
 

