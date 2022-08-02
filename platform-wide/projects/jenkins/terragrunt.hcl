include {
  path = find_in_parent_folders("root-terragrunt.hcl")
}

terraform {
  # source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  source = "${get_parent_terragrunt_dir()}/./tf-modules//project"
}

inputs = {
  project_tag   = "jenkins",
  project_group = "system",
  include_group_in_ecr_name = true # for compatibility with project module changes

  owner         = "devops"
}
