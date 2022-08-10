output "rds_arn" {
  value = module.rds-aurora.this_rds_cluster_arn
}

output "rds_endpoint" {
  value = module.rds-aurora.this_rds_cluster_endpoint
}

output "rds_master_password" {
  value     = random_password.rds_master_password.result
  sensitive = true
}
