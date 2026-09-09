variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "my-ecs-app"
}

# Existing ALB subnets
variable "alb_subnet_ids" {
  type = list(string)
}

# Existing ECS subnets
variable "ecs_subnet_ids" {
  type = list(string)
}

# Existing ECS security group
variable "ecs_security_group_id" {
  type = string
}

# Existing ALB security group
variable "alb_security_group_id" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "ecs_cpu" {
  type    = number
  default = 512
}

variable "ecs_memory" {
  type    = number
  default = 1024
}