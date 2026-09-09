aws_region   = "ap-south-1"
project_name = "my-ecs-app"

alb_subnet_ids = [
  "subnet-xxxxxxxx",
  "subnet-yyyyyyyy"
]

ecs_subnet_ids = [
  "subnet-aaaaaaaa",
  "subnet-bbbbbbbb"
]

alb_security_group_id = "sg-xxxxxxxx"

ecs_security_group_id = "sg-yyyyyyyy"

container_image = "nginx:latest"

container_port = 8080

desired_count = 2

ecs_cpu = 512

ecs_memory = 1024