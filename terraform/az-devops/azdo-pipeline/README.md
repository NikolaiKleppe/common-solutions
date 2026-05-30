# azdo-pipeline

Terraform module that creates an Azure DevOps ARM service connection using Workload Identity Federation (OIDC) backed by a user-assigned managed identity.

## What this module creates

- New resource group for identity resources.
- User-assigned managed identity.
- RBAC role assignments at subscription or management-group scope.
- Federated identity credential for Azure DevOps OIDC.
- Azure DevOps ARM service connection configured for Workload Identity Federation.

## Requirements

- Terraform `>= 1.6.0`
- `hashicorp/azurerm` `~> 4.26`
- `microsoft/azuredevops` `~> 1.0`
- `hashicorp/time` `~> 0.12`

## Inputs (high level)

- `scope_type`: `subscription` or `management_group`
- `subscription_id` / `management_group_id`: required based on selected `scope_type`
- `role_assignments`: list of assignments with `role_definition_name` or `role_definition_id`
- `azure_devops_organization_id`: Azure DevOps organization GUID used for issuer URL

## Notes

- Federated subject is auto-generated as:
  - `sc://<organization_name>/<project_name>/<service_connection_name>`
- Issuer is built as:
  - `https://vstoken.dev.azure.com/<organization_id>`
- A configurable propagation delay is included to reduce first-apply race conditions.

## Example

See `examples/main.tf` for module usage.

Use `examples/example.subscription.tfvars` as a complete subscription-scope input sample.
Use `examples/example.management-group.tfvars` as a complete management-group-scope input sample.

```powershell
terraform -chdir=terraform/az-devops/azdo-pipeline init
terraform -chdir=terraform/az-devops/azdo-pipeline plan -var-file=examples/example.subscription.tfvars
terraform -chdir=terraform/az-devops/azdo-pipeline apply -var-file=examples/example.subscription.tfvars

terraform -chdir=terraform/az-devops/azdo-pipeline plan -var-file=examples/example.management-group.tfvars
terraform -chdir=terraform/az-devops/azdo-pipeline apply -var-file=examples/example.management-group.tfvars
```

After apply, run `examples/azure-pipelines-smoke.yml` in Azure DevOps to verify the created service connection can authenticate and call ARM.
