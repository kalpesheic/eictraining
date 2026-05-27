data "aws_eks_addon_version" "metrics_server_latest" {
  addon_name         = "metrics-server"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

resource "aws_eks_addon" "metrics_server" {
  cluster_name      = aws_eks_cluster.main.name
  addon_name        = "metrics-server"
  addon_version     = data.aws_eks_addon_version.metrics_server_latest.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.main
  ]
}

output "metrics_server_version" {
  value = aws_eks_addon.metrics_server.addon_version
}