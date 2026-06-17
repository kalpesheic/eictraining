################################################################################
# Namespace
################################################################################

resource "kubernetes_namespace" "istio_system" {
  count = var.istio_enabled ? 1 : 0

  metadata {
    name = "istio-system"
  }
}



################################################################################
# Istio Base CRDs
################################################################################

resource "helm_release" "istio_base" {
  count = var.istio_enabled ? 1 : 0

  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = false

  wait    = true
  timeout = 600
}

################################################################################
# Istiod Control Plane
################################################################################

resource "helm_release" "istiod" {
  count = var.istio_enabled ? 1 : 0

  depends_on = [
    helm_release.istio_base
  ]

  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"
  create_namespace = false

  values = [
    yamlencode({
      global = {
        meshID      = "mesh1"
        multiCluster = {
          clusterName = var.cluster_name
        }
      }
    })
  ]

  wait    = true
  timeout = 600
}

################################################################################
# Ingress Namespace
################################################################################

resource "kubernetes_namespace" "istio_ingress" {
  count = var.istio_enabled ? 1 : 0

  metadata {
    name = "istio-ingress"
  }
}

################################################################################
# Istio Ingress Gateway
################################################################################

resource "helm_release" "istio_ingress_gateway" {
  count = var.istio_enabled ? 1 : 0

  depends_on = [
    helm_release.istiod,
    helm_release.aws_load_balancer_controller
  ]

  name             = "istio-ingressgateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "istio-ingress"
  create_namespace = false

  values = [
    yamlencode({
      labels = {
        istio = "ingressgateway"
      }

      service = {
        type = "LoadBalancer"

        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type"            = "external"
          "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
          "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
        }
      }
    })
  ]

  wait    = true
  timeout = 600
}

### added code for the aws load balancer controller 

resource "helm_release" "aws_load_balancer_controller" {

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = "ap-south-1"
      vpcId       = "vpc-02358ddc1cb955bcd"

      serviceAccount = {
        create = false
        name   = "aws-load-balancer-controller"
      }
    })
  ]

  timeout = 600
  wait    = true

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.private_nodes
  ]
}