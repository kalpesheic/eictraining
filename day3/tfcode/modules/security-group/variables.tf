variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "Allowed SSH IP"
  type        = string
}

variable "owner" {
  type = string
}


variable "department" {
  type = string
}

variable "project_name" {
  type = string
}
