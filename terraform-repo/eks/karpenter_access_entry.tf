resource "aws_eks_access_entry" "karpenter_node_access" {
  cluster_name  = local.eks_cluster_name
  principal_arn = aws_iam_role.karpenter_node.arn
  type          = "EC2_LINUX"
}
