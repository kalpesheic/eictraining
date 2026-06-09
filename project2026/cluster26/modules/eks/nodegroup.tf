resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.eks_cluster_name}-private"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids = var.private_subnet_ids

  instance_types = var.node_instance_types
  capacity_type  = var.node_capacity_type
  #disk_size      = var.node_disk_size

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }
 

# Tags for the node group and associated EC2 instances
  tags = merge(var.tags, {
    # Standard EC2 name tag
    Name = "${local.name}-private-ng"

    # Logical environment (e.g., dev, prod)
    Environment = var.environment_name
  })

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly
  ]
}

