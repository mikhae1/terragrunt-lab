module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "12.2.0"
  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  subnets         = var.vpc_private_subnets
  # cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.public_access_cidrs

  enable_irsa      = true
  write_kubeconfig = false
  manage_aws_auth  = false
  # write_aws_auth_config = false

  vpc_id      = var.vpc_id
  node_groups = var.eks_node_groups
}

data "aws_eks_cluster" "current" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "current" {
  name = module.eks.cluster_id
}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id    = data.aws_caller_identity.current.account_id
  aws_oidc_provider = trimprefix(module.eks.cluster_oidc_issuer_url, "https://")
}
