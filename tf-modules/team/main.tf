resource "aws_iam_user" "users" {
  for_each      = toset(var.users)
  name          = each.value
  force_destroy = true
  tags = {
    Team = var.team_slug
  }
}

resource "aws_iam_access_key" "this" {
  for_each = toset(var.users)
  user     = each.value
  depends_on = [aws_iam_user.users]
}

# It's fine to output the secret as long as we run Terraform on laptops.
# Will need to re-think this when we move to CI
output "keys" {
  value = aws_iam_access_key.this
}

data "aws_iam_policy_document" "developer" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:PutImageTagMutability",
      "ecr:StartImageScan",
      "ecr:ListTagsForResource",
      "ecr:UploadLayerPart",
      "ecr:BatchDeleteImage",
      "ecr:ListImages",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetLifecyclePolicy",
      "ecr:DescribeImageScanFindings",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetDownloadUrlForLayer",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:InitiateLayerUpload",
      "ecr:GetRepositoryPolicy"
    ]
    resources = [
      "arn:aws:ecr:*:636164200243:repository/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ecr:ResourceTag/Owner"
      values   = [var.team_slug]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
  
  statement {
    effect    = "Allow"
    actions   = ["logs:DescribeLogGroups"]
    resources = ["*"]
    }
  statement {
    effect    = "Allow"
    actions   = [
      "logs:DescribeLogStreams",
      "logs:ListTagsLogGroup",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
      ]
    resources = ["arn:aws:logs:${var.aws_region}:636164200243:log-group:/aws/containerinsights/dev/application:*"]
    }
}

resource "aws_iam_user_policy" "developer" {
  for_each = toset(var.users)
  name     = "Developer"
  policy   = data.aws_iam_policy_document.developer.json
  user     = each.value
  depends_on = [aws_iam_user.users]
}

