// This module creates a CloudFront distribution and a respective DNS record

module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"
  version = "2.6.0"

  aliases = ["age-gate-${var.env}.${var.cluster_domain}"]

  comment             = "age-gate-${var.env}"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  origin = {
    alb = {
      domain_name = var.alb_domain_name
      custom_origin_config = {
        http_port = 80
        https_port = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
      custom_header = [
        {
          name = "X-CDN-Token"
          value = var.cdn_token
        }
      ]
    }
  }

  default_cache_behavior = {
    target_origin_id       = "alb"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    use_forwarded_values     = false
    cache_policy_id          = aws_cloudfront_cache_policy.behavior["default"].id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.this.id
  }

  custom_error_response = [
    {
      error_code = 404
      error_caching_min_ttl = 0
    }
  ]

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "alb"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      use_forwarded_values     = false
      cache_policy_id          = aws_cloudfront_cache_policy.behavior-static.id
      origin_request_policy_id = aws_cloudfront_origin_request_policy.this.id
    },
    {
      path_pattern           = "/api/*"
      target_origin_id       = "alb"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      use_forwarded_values     = false
      cache_policy_id          = aws_cloudfront_cache_policy.behavior["api"].id
      origin_request_policy_id = aws_cloudfront_origin_request_policy.this.id
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = var.cluster_domain_wildcard_cert_arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    "ProjectTag" = "age-gate"
    "eks:cluster-name" = var.cluster_name
  }

}

data "aws_route53_zone" "selected" {
  name         = var.cluster_domain
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "1.5.0"
  zone_name = var.cluster_domain
  records = [
    {
      name    = "age-gate-${var.env}"
      type    = "A"
      alias   = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    }
  ]
}