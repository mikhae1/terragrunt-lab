include {
  path = find_in_parent_folders("root-terragrunt.hcl")
}

terraform {
  # source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  source = "${get_parent_terragrunt_dir()}/./tf-modules//team"
}

inputs = {
  team_name = "Dev"
  team_slug = "dev"
  users     = ["albus@truek.tr", "evgen@toptal.com"]
}
