variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "aws_peering_accepter_vpc_id" {
  description = "VPC Peering Connection"
  type        = string
}

variable "peer_cidr_block" {
  description = "VPC Peer CIDR block"
  type        = string
}
