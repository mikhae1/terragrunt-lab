include {
  path = find_in_parent_folders("root-terragrunt.hcl")
}

terraform {
  # source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  source = "${get_parent_terragrunt_dir()}/./tf-modules//aws_vpc_for_eks"
}

locals {
  common_vars  = read_terragrunt_config(find_in_parent_folders("common-vars.hcl"), { inputs = {} })
  cluster_vars = read_terragrunt_config(find_in_parent_folders("cluster-vars.hcl"), { inputs = {} })
}

inputs = merge(
  local.cluster_vars.inputs,
  {
    vpc_cidr_block = "10.99.0.0/16"
    aws_peering_accepter_vpc_id = "pcx-0b85e9072d9c4756a"
    peer_cidr_block = "172.21.0.0/16"
  },
)
