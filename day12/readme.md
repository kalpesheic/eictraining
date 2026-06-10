resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

# resolve_conflicts_on_create = "OVERWRITE"
if configuration already exist, terrafrom will overwrite the existing configuration
# resolve_conflicts_on_update = "OVERWRITE"
if existing config differs, or someone manually changed setting, terrafrom overwrites those changes.

  set = [
    {
      name  = "syncSecret.enabled"
      value = "true"
    },
    {
      name  = "tokenRequests[0].audience"
      value = "pods.eks.amazonaws.com"
    },
  ]
#  --set key=value
Terraform passes these values into the Helm chart or addon configuration.

# tokenRequests:
  - audience: pods.eks.amazonaws.com
  This token will be used by EKS pods.

  # data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.main.id
}
Generates an autentication token for the EKS cluster, TF need temporary toekn to, install helm charts, create namespaces, create service account 
# appVersion refers to the actual application version running inside the chart.
which is define in chart.yaml
version- helm chart version
appVersion- Actual application version
 # example
 helm chart version -15.2.1
 Nginx application version = 1.27.0

 that means 
 chart package version -> 15.2.1
 Nginx software version -> 1.27.0