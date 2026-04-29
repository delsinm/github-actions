# Github Actions Repository

Github Actions for various tasks. Includes sample terraform for required IAM implementation.

## Actions

**[git-to-s3-sync](actions/git-to-s3-sync/)** syncs the repository contents to an S3 bucket on every merge to main. Skips documentation and workflow file changes so only meaningful code changes trigger a sync.

**[terraform](actions/terraform/)** is a simple single-job Terraform pipeline suited for individual use. Runs a format check and posts the plan as a PR comment on every push, then applies on merge to main.

**[terraform-pipeline](actions/terraform-pipeline/)** is a more robust multi-job Terraform pipeline that adds parallel security scanning with Checkov, pip caching, and comment search and replace to keep PR threads clean. Recommended for team use.

**[slack-notifications](actions/slack-notifications/)** is a GitHub action to notify Slack on commit and merge. Use this as stand-alone code or add it to your existing GitHub actions(recommended).

## Project Structure

```
github-actions/
├── actions/
│   └── git-to-s3-sync                        # Syncs GitHub repo to S3 bucket
│   └── terraform                             # Simple Terraform pipeline
│   └── terraform-pipeline                    # Advanced Terraform pipeline
│   └── slack-notifications                   # Slack notifications
├── terraform/
│   ├── github_actions_role_variables.tf      # Terraform variables
│   └── github_actions_role.tf                # Terraform IAM code
```
