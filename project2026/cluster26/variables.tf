variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "environment_name" {
  description = "Environment name used in resource names and tags"
  type        = string
  default     = "dev-kalpesh"
}


variable "tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform = "true"
  }
}



