variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "key_name" {
  description = "Existing AWS EC2 Key Pair Name"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "Your Public IP with /32"
  type        = string
}

variable "owner" {
  type = string
}

variable "project_name" {
  type = string
}

variable "department" {
  type = string
}


