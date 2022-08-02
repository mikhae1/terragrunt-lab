data "aws_caller_identity" "current" {}

// projectTag is the identificator of all project assets.
// projectGroup is here just for billing reporting simplification
resource "aws_ecr_repository" "this" {
  name = var.include_group_in_ecr_name ? "${var.project_group}/${var.project_tag}" : var.project_tag
  tags = {
    ProjectGroup = var.project_group
    ProjectTag   = var.project_tag
    Owner        = var.owner
  }
}

// AWS doesn't allow tag-based access to S3 buckets (only objects), 
// i.e. there's no Condition Key for S3 to specify bucket tags
// (see https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazons3.html),
// so we have to set that vice versa: as a bucket policy with aws:PrincipalTag condition
data "aws_iam_policy_document" "artefacts_policy_doc" {
  count = var.create_artefacts_bucket ? 1 : 0
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/Team"
      values   = [var.owner, "jenkins", "salmon-technical"]
    }
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.artefacts[count.index].arn
    ]
  }
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/Team"
      values   = [var.owner, "jenkins", "salmon-technical"]
    }
    actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:PutObject",
      "s3:PutObjectTagging",
      "s3:PutObjectAcl",
    ]
    resources = [
      "${aws_s3_bucket.artefacts[count.index].arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "artefacts" {
  count  = var.create_artefacts_bucket ? 1 : 0
  bucket = "${var.project_tag}-artefacts"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
  tags = {
    ProjectGroup = var.project_group
    ProjectTag   = var.project_tag
    Owner        = var.owner
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.create_artefacts_bucket ? 1 : 0
  bucket = aws_s3_bucket.artefacts[count.index].id
  policy = data.aws_iam_policy_document.artefacts_policy_doc[count.index].json
}
