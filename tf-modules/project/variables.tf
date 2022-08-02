variable "aws_region" {
  type = string
}

variable "project_tag" {
  description = "Project tag"
  type        = string
}

variable "project_group" {
  description = "Project group"
  type        = string
  default     = ""
}

variable "include_group_in_ecr_name" {
  description = "Create ECR Repo Name with Project_Group"
  type        = bool
  default     = false
}

variable "owner" {
  description = "Team slug"
  type        = string
}

variable "create_artefacts_bucket" {
  description = "Whether to create S3 bucket for artefacts or not"
  type        = bool
  default     = false
}

variable "create_assets_bucket" {
  description = "Whether to create S3 bucket for assets or not"
  type        = bool
  default     = false
}

variable "create_assets_cloudfront" {
  description = "Whether to create Cloudfront distribution for assets or not"
  type        = bool
  default     = false
}

variable "email_addresses" {
  description = "List of the approved email addresses for sending emails"
  type        = list(string)
  default     = []
}
