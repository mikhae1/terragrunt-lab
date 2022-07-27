remote_state {
  backend = "s3"
  config = {
    bucket         = get_env("S3_BUCKET", "lab-terraform-state-k3e02ifn9290")
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
  }
}

inputs = {
  aws_region = "us-east-1"
}

# In some cases, the root level terragrunt.hcl file is solely used to DRY up
# your Terraform configuration by being included in the other terragrunt.hcl files.
# In this case, you do not want the xxx-all commands to process the root level
# terragrunt.hcl since it does not define any infrastructure by itself.
skip = true

# terraform_version_constraint  = "= 1.2.5"
# terragrunt_version_constraint = ">= 0.38"

# Terragrunt will generate the file "provider.tf" with the aws provider block
# before calling to terraform. Note that this will overwrite the `provider.tf`
# file if it already exists.
generate "provider" {
  path      = "basic_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region              = var.aws_region
  version             = "3.42.0"
}
EOF
}
