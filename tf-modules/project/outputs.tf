# It's fine to output the secret as long as we run Terraform on laptops.
# Will need to re-think this when we move to CI
output "smtp_user_id" {
  value = join("", aws_iam_access_key.smtp_user_keys[*].id)
}

output "smtp_user_password" {
  value = join("", aws_iam_access_key.smtp_user_keys[*].ses_smtp_password_v4)
}

output "assets_cloudfront_domain" {
  value = join("", aws_cloudfront_distribution.this[*].domain_name)
}

// output "assets_s3_bucket_arn" {
//   value = join("", aws_s3_bucket.assets[*].arn)
// }

// output "assets_s3_bucket_region" {
//   value = join("", aws_s3_bucket.assets[*].region)
// }

// output "assets_s3_bucket_url" {
//   value = join("", aws_s3_bucket.assets[*].bucket_regional_domain_name)
// }
