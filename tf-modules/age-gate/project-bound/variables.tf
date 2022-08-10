variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "instance_type" {
  description = "DB instance type"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_public_subnets" {
  description = "VPC public subnets to deploy Age-Gate RDS to"
  type        = list
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access Age-Gate RDS"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "cluster_security_group_id" {
  description = "EKS cluster security group to allow access from"
  type        = string
}

variable "replica_count" {
  description = "RDS replica count"
  type        = number
}
