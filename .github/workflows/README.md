# Reusable Azure Terraform Workflows

This directory provides reusable workflow templates for Terraform plan/apply with Azure OIDC authentication.

## Templates

- `terraform-deploy-template.yml`: Single reusable workflow with two jobs, `plan` and `apply`. The `apply` job needs `plan` and only runs when `run_apply` is true and the plan reported changes.

## Actions

All steps that repeat across jobs are extracted into composite actions under `.github/actions/`, referenced with the `$/` self-reference syntax (resolves to this repository at the running commit, no checkout required):

- `.github/actions/azure-login/action.yml`: Azure OIDC login, with or without an explicit subscription.
- `.github/actions/terraform-init/action.yml`: Azure login (via the action above) + Terraform setup + `terraform init` with explicit `-backend-config` flags.
- `.github/actions/terraform-plan/action.yml`: Runs `terraform plan`, exposes `has_changes`, and uploads the plan artifact.
- `.github/actions/terraform-apply/action.yml`: Downloads the plan artifact and runs `terraform apply`.
- `.github/actions/terraform-plan-render-summary/action.yml`: Converts a Terraform binary plan into a one-line add/change/destroy summary. See its README for inputs/outputs/usage.
- `.github/actions/terraform-plan-pr-comment/action.yml`: Posts/refreshes the plan summary as a PR comment.

Note: the `$/` syntax requires GitHub Actions runner 2.336.0 or newer.

## OIDC Requirements

Consumer repositories must provide the following reusable workflow secrets:

- `azure_client_id`
- `azure_tenant_id`

The Azure identity behind `azure_client_id` must have a federated credential for GitHub Actions and sufficient RBAC permissions at the target scope.

Caller workflows must grant these job permissions when invoking the reusable workflow:

- `contents: read`
- `id-token: write`

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

`run_apply` controls whether the `apply` job runs. By default, only the `plan` job executes.

## Terraform Init Backend Flags

The `terraform-init` action always executes Terraform init with backend config flags:

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
		permissions:
			contents: read
			id-token: write
		uses: <owner>/<repo>/.github/workflows/terraform-deploy-template.yml@main
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
		permissions:
			contents: read
			id-token: write
		uses: <owner>/<repo>/.github/workflows/terraform-deploy-template.yml@main
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
		permissions:
			contents: read
			id-token: write
		uses: <owner>/<repo>/.github/workflows/terraform-deploy-template.yml@main
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
