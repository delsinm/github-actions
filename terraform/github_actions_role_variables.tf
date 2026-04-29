# ============================================================================
# Variables
# ============================================================================

variable "github_owner" {
  description = "GitHub username or organisation that owns the repository."
  type        = string
}

variable "github_repo" {
  description = "Repository name (without the owner prefix)."
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket the GitHub Actions role is allowed to sync to."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
