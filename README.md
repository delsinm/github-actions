# github-actions
Github Actions for various tasks. Includes sample terraform for required IAM implementation.

## Project Structure

```
jira-dashboard/
├── actions/
│   └── git-to-s3-sync                        # Syncs GitHub repo codebase to S3 bucket on commit
│   └── terraform                             # Simple Terraform pipeline; suitable for individual use, lab environments, etc.
│   └── terraform-pipeline                    # Robust Terraform pipeline that includes security scanning
├── terraform/
│   ├── github_actions_role_variables.tf      # Terraform variables for GitHub actions IAM role
│   └── github_actions_role.tf                # Terraform code for GitHub actions IAM role
```
