
resource "aws_ec2_tag" "eks_subnet_tag_public_alb" {
    for_each = toset(var.public_subnet_ids)
    resource_id = each.value
    key         = "kubernetes.io/role/elb"
    value       = "1"
}

resource "aws_ec2_tag" "eks_subnet_tag_public_cluster" {
  for_each    = toset(var.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${local.eks_cluster_name}"
  value       = "shared"
}


resource "aws_ec2_tag" "private_internal_elb" {
  for_each = toset(var.private_subnet_ids)

  resource_id = each.value

  key   = "kubernetes.io/role/internal-elb"
  value = "1"
}
resource "aws_ec2_tag" "cluster_private" {
  for_each = toset(var.private_subnet_ids)
  resource_id = each.value
  key   = "kubernetes.io/cluster/${aws_eks_cluster.main.name}"
  value = "shared"
}