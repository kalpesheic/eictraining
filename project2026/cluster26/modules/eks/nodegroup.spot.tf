resource "aws_eks_node_group" "spot_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.eks_cluster_name}-spot"

  node_role_arn = aws_iam_role.eks_nodes.arn
  subnet_ids    = var.private_subnet_ids

  instance_types = [
    "t3.medium",
    "t3a.medium",
     "t2.medium"

  ]

  capacity_type = "SPOT"

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  labels = {
    lifecycle = "spot"
  }

  tags = merge(var.tags, {
    Name        = "${local.name}-spot-ng"
    Environment = var.environment_name
  })

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly
  ]
}