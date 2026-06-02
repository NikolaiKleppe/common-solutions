# Reusable Azure Terraform Workflows

This directory provides reusable workflow templates for Terraform plan/apply with Azure OIDC authentication.

## Templates

- `azure-terraform-plan-apply-template.yml`: Main reusable workflow that orchestrates init, plan, and optional apply.
- `terraform-component-init.yml`: Child template for Terraform init.
- `terraform-component-plan.yml`: Child template for Terraform plan.
- `terraform-component-apply.yml`: Child template for Terraform apply.

## Shared Component

- `.github/actions/terraform-component-init/action.yml`: Shared component used by child templates to run checkout, Azure OIDC login, Terraform setup, and `terraform init` with explicit `-backend-config` flags.

## OIDC Requirements

Consumer repositories must provide the following reusable workflow secrets:

- `azure_client_id`
- `azure_tenant_id`

The Azure identity behind `azure_client_id` must have a federated credential for GitHub Actions and sufficient RBAC permissions at the target scope.

## Required Inputs

Main workflow required inputs:

- `terraform_working_directory`
- `backend_resource_group_name`
- `backend_storage_account_name`
- `backend_container_name`
- `backend_key`

Optional inputs:

- `terraform_version` (default: `1.5.7`)
- `tfvars_file` (default: empty)
- `azure_subscription_id` (default: empty)
- `backend_subscription_id` (default: empty)
- `run_apply` (default: `false`)

`run_apply` controls whether the apply child template runs. By default, only init and plan execute.

## Terraform Init Backend Flags

The shared init component always executes Terraform init with backend config flags:

- `-backend-config="resource_group_name=..."`
- `-backend-config="storage_account_name=..."`
- `-backend-config="container_name=..."`
- `-backend-config="key=..."`

If `backend_subscription_id` is provided, init also includes:

- `-backend-config="subscription_id=..."`

## Management Group Support

Management group deployments are supported.

- For management group-only authentication, omit `azure_subscription_id` input and OIDC login will use `allow-no-subscriptions: true`.
- For subscription-scoped authentication, pass `azure_subscription_id` as a workflow input (for example from repository variable `AZURE_SUBSCRIPTION_ID`).
- If your Terraform backend storage account is in a specific subscription, set `backend_subscription_id` so `terraform init` can resolve the backend.

## Consumer Example (Plan Only)

```yaml
name: Plan Infrastructure

on:
	pull_request:
		paths:
			- "terraform/**"
			- ".github/workflows/**"

jobs:
	terraform:
		uses: <owner>/<repo>/.github/workflows/azure-terraform-plan-apply-template.yml@main
		with:
			terraform_working_directory: terraform/key-vault
			tfvars_file: terraform.tfvars
			azure_subscription_id: ${{ vars.AZURE_SUBSCRIPTION_ID }}
			backend_resource_group_name: rg-common-solutions-tfstate
			backend_storage_account_name: tfstatecommontc7iagly
			backend_container_name: tfstate
			backend_key: common/az-keyvault.tfstate
			run_apply: false
		secrets:
			azure_client_id: ${{ secrets.AZURE_CLIENT_ID }}
			azure_tenant_id: ${{ secrets.AZURE_TENANT_ID }}
```

## Consumer Example (Plan And Apply)

```yaml
name: Apply Infrastructure

on:
	workflow_dispatch:

jobs:
	terraform:
		uses: <owner>/<repo>/.github/workflows/azure-terraform-plan-apply-template.yml@main
		with:
			terraform_working_directory: terraform/key-vault
			tfvars_file: terraform.tfvars
			azure_subscription_id: ${{ vars.AZURE_SUBSCRIPTION_ID }}
			backend_resource_group_name: rg-common-solutions-tfstate
			backend_storage_account_name: tfstatecommontc7iagly
			backend_container_name: tfstate
			backend_key: common/az-keyvault.tfstate
			run_apply: true
		secrets:
			azure_client_id: ${{ secrets.AZURE_CLIENT_ID }}
			azure_tenant_id: ${{ secrets.AZURE_TENANT_ID }}
```

## Consumer Example (Management Group)

```yaml
name: Plan Management Group Infrastructure

on:
	workflow_dispatch:

jobs:
	terraform:
		uses: <owner>/<repo>/.github/workflows/azure-terraform-plan-apply-template.yml@main
		with:
			terraform_working_directory: terraform/az-devops/azdo-pipeline
			tfvars_file: examples/example.management-group.tfvars
			backend_resource_group_name: rg-common-solutions-tfstate
			backend_storage_account_name: tfstatecommontc7iagly
			backend_subscription_id: ${{ vars.TFSTATE_SUBSCRIPTION_ID }}
			backend_container_name: tfstate
			backend_key: common/azdo-mg.tfstate
			run_apply: false
		secrets:
			azure_client_id: ${{ secrets.AZURE_CLIENT_ID }}
			azure_tenant_id: ${{ secrets.AZURE_TENANT_ID }}
```
