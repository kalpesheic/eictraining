variable "environment_name" {
  type    = string
  default = "dev-kalpesh"
}

variable "tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }
}

variable "nat_gateway_id" {
  type    = string
  default = null
}