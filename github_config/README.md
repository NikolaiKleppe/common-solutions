# GitHub Actions Repository Configuration

This Terraform stack configures the GitHub Actions repository secrets and variable required by the reusable Terraform workflow templates.

It also creates a protected GitHub Actions environment used to gate Terraform apply.

## Creates

- Secret `AZURE_CLIENT_ID`
- Secret `AZURE_TENANT_ID`
- Variable `AZURE_SUBSCRIPTION_ID` (optional, only when provided)
- Variable `TFSTATE_SUBSCRIPTION_ID`
- Environment `terraform-apply` by default

## Required environment variable

Set a GitHub token that can manage repository Actions settings:

```powershell
$env:GITHUB_TOKEN = "<token-with-repo-and-actions-admin-permissions>"
```

## Example terraform.tfvars

```hcl
github_owner            = "your-org"
repository_name         = "common-solutions"
azure_tenant_id         = "11111111-1111-1111-1111-111111111111"
azure_subscription_id   = "22222222-2222-2222-2222-222222222222"
tfstate_subscription_id = "33333333-3333-3333-3333-333333333333"
service_principal_display_name = "common-solutions-github-config-sp"
apply_environment_name   = "terraform-apply"

apply_environment_reviewer_usernames = ["your-github-username"]
# or
apply_environment_reviewer_team_slugs = ["your-team-slug"]
```

For management group-only auth, set `azure_subscription_id = ""`.

## Run

```powershell
terraform -chdir=github_config init
terraform -chdir=github_config plan
terraform -chdir=github_config apply
```