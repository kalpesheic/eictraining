
variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}


variable "key_name" {
  description = "Existing AWS Key Pair"
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

variable "security_group_id" {
  description = "Security Group ID for EC2"
  type        = string
}