output "dns_record" {
  value = module.records.this_route53_record_fqdn
}

output "cloudfront" {
  value = module.cloudfront.cloudfront_distribution_domain_name
}
