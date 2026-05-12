**[git-to-s3-sync](git-to-s3-sync/)** syncs the repository contents to an S3 bucket on every merge to main. Skips documentation and workflow file changes so only meaningful code changes trigger a sync.

**[terraform](terraform/)** is a simple single-job Terraform pipeline suited for individual use. Runs a format check and posts the plan as a PR comment on every push, then applies on merge to main.

**[terraform-pipeline](terraform-pipeline/)** is a more robust multi-job Terraform pipeline that adds parallel security scanning with Checkov, pip caching, and comment search and replace to keep PR threads clean. Recommended for team use.

**[slack-notifications](slack-notifications/)** is a GitHub action to notify Slack on commit and merge. Use this as stand-alone code or add it to your existing GitHub actions(recommended).
