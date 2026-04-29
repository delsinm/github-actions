# Github Actions Repository
Github Actions for various tasks. Includes sample terraform for required IAM implementation in the terraform directory.

## Actions

**[git-to-s3-sync](actions/git-to-s3-sync/README.md)** syncs the repository contents to an S3 bucket on every merge to main. Skips documentation and workflow file changes so only meaningful code changes trigger a sync.

**[terraform](actions/terraform/README.md)** is a simple single-job Terraform pipeline suited for individual use. Runs a format check and posts the plan as a PR comment on every push, then applies on merge to main.

**[terraform-pipeline](actions/terraform-pipeline/README.md)** is a more robust multi-job Terraform pipeline that adds parallel security scanning with Checkov, path-based triggers, pip caching, and comment search and replace to keep PR threads clean. Recommended for team use.

## Project Structure

```
jira-dashboard/
├── actions/
│   └── git-to-s3-sync                        # Syncs GitHub repo to S3 bucket
│   └── terraform                             # Simple Terraform pipeline
│   └── terraform-pipeline                    # Advanced Terraform pipeline
├── terraform/
│   ├── github_actions_role_variables.tf      # Terraform variables
│   └── github_actions_role.tf                # Terraform IAM code
```
