resource "aws_cloudfront_distribution" "this" {
  count = var.create_assets_bucket && var.create_assets_cloudfront ? 1 : 0

  comment = "S3-${var.project_tag}-assets"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "S3-${var.project_tag}-assets"
    viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  enabled = true

  origin {
    origin_id   = "S3-${var.project_tag}-assets"
    domain_name = aws_s3_bucket.assets[count.index].bucket_regional_domain_name
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    ProjectGroup = var.project_group
    ProjectTag   = var.project_tag
    Owner        = var.owner
  }
}
