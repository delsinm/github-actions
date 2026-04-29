# ============================================================================
# GitHub Actions OIDC IAM Role
# ============================================================================
#
# Creates an IAM role that GitHub Actions can assume via OIDC — no long-lived
# AWS credentials required.
#
# Prerequisites:
#   The GitHub OIDC provider must exist in your AWS account. This is a one-time
#   account-level setup. If it already exists, import it rather than creating
#   a duplicate:
#
#   terraform import aws_iam_openid_connect_provider.github \
#     arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com
# ============================================================================

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# ----------------------------------------------------------------------------
# GitHub OIDC Provider
# Registers GitHub as a trusted identity provider in this AWS account.
# ----------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  # AWS uses this to identify the intended audience of the token.
  client_id_list = ["sts.amazonaws.com"]

  # Thumbprint of the GitHub OIDC certificate.
  # This is a static value maintained by GitHub — it rarely changes.
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# ----------------------------------------------------------------------------
# Trust policy — controls who can assume this role.
# Locked to a specific GitHub repo and optionally a specific branch.
# ----------------------------------------------------------------------------

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    # sub takes the format: repo:{owner}/{repo}:ref:refs/heads/{branch}
    # Using StringLike with a wildcard allows all branches, or lock it down
    # to a specific branch by replacing * with e.g. "ref:refs/heads/main".
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}/${var.github_repo}:*"]
    }

    # Ensures the token was intended for AWS — prevents confused deputy attacks.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------------------
# IAM Role
# ----------------------------------------------------------------------------

resource "aws_iam_role" "github_actions" {
  name               = "${var.github_owner}-${var.github_repo}-github-actions"
  description        = "Assumed by GitHub Actions in ${var.github_owner}/${var.github_repo} via OIDC."
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
  tags               = var.tags
}

# ----------------------------------------------------------------------------
# S3 permissions — least privilege, scoped to the specific bucket.
# ----------------------------------------------------------------------------

data "aws_iam_policy_document" "s3_sync" {
  statement {
    sid    = "S3Sync"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",   # needed for the --delete flag in aws s3 sync
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]
  }
}

resource "aws_iam_role_policy" "s3_sync" {
  name   = "s3-sync"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.s3_sync.json
}

# ----------------------------------------------------------------------------
# Outputs
# ----------------------------------------------------------------------------

output "role_arn" {
  description = "ARN of the IAM role. Store this as AWS_ROLE_ARN in GitHub Secrets."
  value       = aws_iam_role.github_actions.arn
}
