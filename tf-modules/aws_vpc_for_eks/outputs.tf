output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_endpoint_ses_dns_entry" {
  value = module.vpc.vpc_endpoint_ses_dns_entry
}

output "default_security_group_id" {
  value = aws_default_security_group.default.id
}
