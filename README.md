# github-actions
Github Actions for various tasks

## Project Structure

```
jira-dashboard/
├── actions/
│   └── git-to-s3-sync                        # Syncs GitHub repo codebase to S3 bucket on commit
│   └── terraform                             # Terraform helper functions
├── terraform/
│   ├── github_actions_role_variables.tf      # Terraform variables for GitHub actions IAM role
│   └── github_actions_role.tf                # Terraform code for GitHub actions IAM role
```
