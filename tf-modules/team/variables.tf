variable "aws_region" {
  type = string
}

variable "team_name" {
  description = "Full name of the team"
  type        = string
}

variable "team_slug" {
  description = "Slug for team name"
  type        = string
}

variable "users" {
  description = "A list of e-mails to create AWS accounts for"
  type        = list(string)
}
