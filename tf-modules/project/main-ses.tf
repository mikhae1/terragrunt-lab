resource "aws_iam_user" "smtp_user" {
  count  =  length(var.email_addresses)>0 ? 1 : 0
  name = "smtp-creds-${var.project_tag}"
}

resource "aws_iam_access_key" "smtp_user_keys" {
  count      =  length(var.email_addresses)>0 ? 1 : 0
  user       = aws_iam_user.smtp_user[count.index].name
  depends_on = [aws_iam_user.smtp_user]
}

data "aws_iam_policy_document" "ses_policy" {
  for_each = toset(var.email_addresses)
  statement {
    effect = "Allow"
    actions = [
        "ses:SendEmail",
        "ses:SendRawEmail"
    ]
    condition {
      test     = "StringEquals"
      variable = "ses:FromAddress"
      values   = [
          each.value
          ]
    }
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_user_policy" "smtp_policy" {
  for_each   = toset(var.email_addresses)
  name       = each.value
  policy     = data.aws_iam_policy_document.ses_policy[each.value].json
  user       = aws_iam_user.smtp_user[0].name
  depends_on = [aws_iam_user.smtp_user]
}
