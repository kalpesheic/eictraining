# below code for the S3 readonly access with PIA assocation

resource "aws_iam_role" "s3_readonly_role" {
name = "${local.eks_cluster_name}-s3-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "pods.eks.amazonaws.com"
      }

      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }]
  })
  tags = {
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.s3_readonly_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

#resource "aws_eks_pod_identity_association" "s3_reader" {
#  cluster_name    = aws_eks_cluster.main.name
#  namespace       = "default"
#  service_account = "s3-reader"

#  role_arn = aws_iam_role.s3_readonly_pod_role.arn
#}
