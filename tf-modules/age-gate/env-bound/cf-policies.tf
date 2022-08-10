
resource "aws_cloudfront_cache_policy" "behavior" {
  for_each = toset([
    "default",
    "api",
    ])
  name        = "age-gate-${var.env}-behavior-${each.key}"
  min_ttl     = 0
  default_ttl = 86400
  max_ttl     = 31536000
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
      // cookies {
      //   items = ["example"]
      // }
    }
    headers_config {
      header_behavior = "whitelist"
        headers {
          items = [
            "Origin",
          ]
        }
    }
    query_strings_config {
      query_string_behavior = "all"
      // query_strings {
      //   items = ["example"]
      // }
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

resource "aws_cloudfront_cache_policy" "behavior-static" {
  name        = "age-gate-${var.env}-behavior-static"
  min_ttl     = 0
  default_ttl = 86400
  max_ttl     = 31536000
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

resource "aws_cloudfront_origin_request_policy" "this" {
  name    = "age-gate-${var.env}"
  cookies_config {
    cookie_behavior = "whitelist"
    cookies {
      items = [
        "AWSALB",
        "AWSALBCORS",
        "AWSALBAPP",
        "AWSALBTG",
      ]
    }
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
        "Referer",
        "User-Agent",
      ]
    }
  }
  query_strings_config {
    query_string_behavior = "all"
    // query_strings {
    //   items = ["example"]
    // }
  }
}
