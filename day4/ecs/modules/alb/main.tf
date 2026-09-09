# --------------------------------------------------
# Existing ALB
# --------------------------------------------------

resource "aws_lb" "this" {

  name = "${var.project_name}-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.alb_subnet_ids

  tags = {
    Project = var.project_name
  }
}


# --------------------------------------------------
# Target Group
# --------------------------------------------------

resource "aws_lb_target_group" "this" {

  name = "${var.project_name}-tg"

  port = var.container_port

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    port = "traffic-port"

    healthy_threshold = 2

    unhealthy_threshold = 3

    interval = 30

    timeout = 5

    matcher = "200-399"
  }

  tags = {
    Project = var.project_name
  }
}


# --------------------------------------------------
# Listener
# --------------------------------------------------

resource "aws_lb_listener" "http" {

  load_balancer_arn =
    aws_lb.this.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn =
      aws_lb_target_group.this.arn
  }
}