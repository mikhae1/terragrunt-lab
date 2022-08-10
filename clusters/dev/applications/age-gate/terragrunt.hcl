include {
  path = find_in_parent_folders("root-terragrunt.hcl")
}

terraform {
  # source = "git::git@gitbud.epam.com:baca-diho/tf-modules.git//blueprints/age-gate/project-bound?ref=age-gate_v1.0.0"
  source = "${get_parent_terragrunt_dir()}/./tf-modules//age-gate/project-bound"
}

dependency "vpc" {
  config_path = "../../core-infrastructure/vpc"
}

# dependency "kubernetes" {
#   config_path = "../../kubernetes"
# }

locals {
  common_vars  = read_terragrunt_config(find_in_parent_folders("common-vars.hcl"), { inputs = {} })
  cluster_vars = read_terragrunt_config(find_in_parent_folders("cluster-vars.hcl"), { inputs = {} })
}

inputs = merge(
  local.cluster_vars.inputs,
  {
    instance_type             = "db.t3.small",
    vpc_id                    = dependency.vpc.outputs.vpc_id,
    vpc_public_subnets        = dependency.vpc.outputs.public_subnets,
    cluster_security_group_id = dependency.vpc.outputs.default_security_group_id
    replica_count             = 1
    # allowed_cidr_blocks       = local.common_vars.inputs.epam_networks
  },
)
