resource "aws_eks_cluster" "main" {
  # Full cluster name built from business + environment + cluster_name
  name = local.eks_cluster_name

  # Kubernetes version to use for the control plane
  version = var.cluster_version

  # IAM role used by EKS to manage the control plane
  role_arn = aws_iam_role.eks_cluster.arn

  # VPC configuration for control plane networking
  vpc_config {
    # Subnets where EKS control plane ENIs will be placed (should be private)
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    #subnet_ids = [
    #data.aws_subnet.private_1.id,
    #data.aws_subnet.private_2.id
    #]
    # Allow access to private endpoint (inside VPC)
    endpoint_private_access = var.cluster_endpoint_private_access

    # Allow access to public endpoint (from internet, controlled via CIDRs)
    endpoint_public_access = var.cluster_endpoint_public_access

    # List of CIDRs allowed to reach the public endpoint
    public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  }

  # Define the service CIDR range used by Kubernetes services (optional)
  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  # Enable EKS control plane logging for visibility and debugging
  enabled_cluster_log_types = [
    "api",               # API server audit logs
    "audit",             # Kubernetes audit logs
    "authenticator",     # Authenticator logs for IAM auth
    "controllerManager", # Logs for controller manager
    "scheduler"          # Logs for pod scheduling
  ]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]
  tags = var.tags
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP" # Three options: CONFIG_MAP, API, API_AND_CONFIG_MAP
    bootstrap_cluster_creator_admin_permissions = true
  }

}

resource "aws_eks_addon" "pod_identity" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "eks-pod-identity-agent"
}

#resource "aws_eks_addon" "ebs_csi" {
#  cluster_name = aws_eks_cluster.main.name
#  addon_name   = "aws-ebs-csi-driver"
#}

#Created policy for the add aws loadbalancer controller policy

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name = "AWSLoadBalancerControllerIAMPolicy_${local.eks_cluster_name}"

  policy = file("${path.module}/policies/aws-load-balancer-controller-policy.json")

  tags = var.tags
}

# create IAM role with attach trust policy 

resource "aws_iam_role" "aws_load_balancer_controller" {
  name               = "AmazonEKS_LBC_Role_${local.eks_cluster_name}"
  assume_role_policy = file("${path.module}/policies/aws-load-balancer-controller-trust-policy.json")
  tags               = var.tags
}

# attach aws load balancer controller policy with IAM role
resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

# create PIA assocation along with attach aws load balancer controller.

resource "aws_eks_pod_identity_association" "aws_load_balancer_controller" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.aws_load_balancer_controller.arn
  depends_on = [
    aws_iam_role_policy_attachment.aws_load_balancer_controller
  ]
}

