# --------------------------------------------------
# ECS Cluster
# --------------------------------------------------

resource "aws_ecs_cluster" "this" {

  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Project = var.project_name
  }
}


# --------------------------------------------------
# CloudWatch Logs
# --------------------------------------------------

resource "aws_cloudwatch_log_group" "this" {

  name              = "/ecs/${var.project_name}"
  retention_in_days = 30

  tags = {
    Project = var.project_name
  }
}


# --------------------------------------------------
# ECS Execution Role
# --------------------------------------------------

resource "aws_iam_role" "execution" {

  name = "${var.project_name}-ecs-execution-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }

    ]
  })
}


resource "aws_iam_role_policy_attachment" "execution" {

  role = aws_iam_role.execution.name

  policy_arn =
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# --------------------------------------------------
# Task Definition
# --------------------------------------------------

resource "aws_ecs_task_definition" "this" {

  family = var.project_name

  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  cpu    = var.cpu
  memory = var.memory

  execution_role_arn = aws_iam_role.execution.arn

  container_definitions = jsonencode([

    {
      name  = "app"
      image = var.container_image

      essential = true

      portMappings = [

        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group =
            aws_cloudwatch_log_group.this.name

          awslogs-region =
            var.aws_region

          awslogs-stream-prefix = "ecs"
        }
      }
    }

  ])

  tags = {
    Project = var.project_name
  }
}


# --------------------------------------------------
# ECS Service
# --------------------------------------------------

resource "aws_ecs_service" "this" {

  name = "${var.project_name}-service"

  cluster = aws_ecs_cluster.this.id

  task_definition =
    aws_ecs_task_definition.this.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.ecs_subnet_ids

    security_groups = [
      var.ecs_security_group_id
    ]

    # IMPORTANT
    assign_public_ip = false
  }

  # Target group will be attached later
  # using ECS service attachment.

  tags = {
    Project = var.project_name
  }

  lifecycle {

    ignore_changes = [
      load_balancer
    ]
  }
}