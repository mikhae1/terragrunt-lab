include {
  path = find_in_parent_folders("root-terragrunt.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/./tf-modules//aws_eks_cluster"
}

dependency "vpc" {
  config_path = "../core-infrastructure/vpc"
}

locals {
  common_vars  = read_terragrunt_config(find_in_parent_folders("common-vars.hcl"), { inputs = {} })
  cluster_vars = read_terragrunt_config(find_in_parent_folders("cluster-vars.hcl"), { inputs = {} })
}

inputs = merge(
  local.cluster_vars.inputs,
  {
    vpc_id                   = dependency.vpc.outputs.vpc_id
    vpc_private_subnets      = dependency.vpc.outputs.private_subnets
    # dns_zone                 = "dev.digital"
    public_access_cidrs      = local.common_vars.inputs.epam_networks
    # parrot_namespace         = "monitoring"
    # parrot_service_account   = "parrot-app"
    kubernetes_version       = "1.21"
    autoscaler_version       = "1.21.2"
    # addon_vpc_cni_version    = "1.10.2-eksbuild.1"
    # addon_coredns_version    = "1.8.4-eksbuild.1"
    # addon_kube_proxy_version = "1.21.2-eksbuild.2"
    eks_node_groups = {
      # group-2 = {
      #   disk_size        = 40
      #   instance_type    = "t3.medium"
      #   version          = "1.21"
      #   subnets          = dependency.vpc.outputs.private_subnets
      #   min_capacity     = 1
      #   desired_capacity = 1 # This value ignored by EKS module, change it through AWS console!
      #   max_capacity     = 1
      # }
    }
  }
)
