resource "aws_launch_template" "eks_nodes" {

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.node_disk_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name        = "${local.name}-worker-node"
      Environment = var.environment_name
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.tags, {
      Name        = "${local.name}-worker-volume"
      Environment = var.environment_name
    })
  }
}