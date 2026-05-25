module "eks" {
  source = "./modules/eks"

  cluster_name = "kalpesh-test-cluster"

  # other variables
}
