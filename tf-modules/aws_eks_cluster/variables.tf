variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS cluster Kubernetes version"
  type        = string
}

variable "eks_node_groups" {
  description = "EKS managed node groups definition"
  type        = map
}


variable "vpc_id" {
  description = "VPC ID to provision cluster to"
  type        = string
}

variable "vpc_private_subnets" {
  description = "VPC private subnets"
  type        = list
}

variable "public_access_cidrs" {
  description = "List of CIDRs to allow access to Kubernetes API from"
  type        = list
}
