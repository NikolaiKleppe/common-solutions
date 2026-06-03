# Terraform Plan Render Summary Action

This composite action renders a concise Terraform plan summary from a binary plan file.

The summary is formatted as one line per resource operation and grouped by operation type in this order:

- ADD
- CHANGE
- DESTROY

Example output lines:

- 🟢 ADD: resource "azurerm_resource_group" "example"
- 🟡 CHANGE: resource "azurerm_storage_account" "sa1"
- 🔴 DESTROY: resource "azurerm_role_assignment" "old"

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| terraform_working_directory | Yes | n/a | Terraform working directory relative to repository root. |
| plan_file_name | No | terraform.tfplan | Terraform binary plan filename in terraform_working_directory. |

## Outputs

| Name | Description |
|---|---|
| plan_summary | One-line-per-resource operation summary suitable for PR comments or logs. |

## Prerequisites

- Terraform must be installed before this action runs.
- The binary plan file must already exist, usually from:
	- terraform plan -out=<plan file>

## Usage

Use the action after your plan step, then consume the output in later steps.

~~~yaml
- name: Render plan summary
	id: show_plan
	uses: ./.github/actions/terraform-plan-render-summary
	with:
		terraform_working_directory: ${{ inputs.terraform_working_directory }}
		plan_file_name: ${{ inputs.plan_file_name }}

- name: Print plan summary
	shell: bash
	run: |
		echo "${{ steps.show_plan.outputs.plan_summary }}"
~~~

## Example With PR Comment Action

~~~yaml
- name: Render plan summary
	id: show_plan
	uses: ./.github/actions/terraform-plan-render-summary
	with:
		terraform_working_directory: terraform/gh-action-examples/deploy-sub-scope
		plan_file_name: terraform.tfplan

- name: Comment plan output on PR
	if: github.event_name == 'pull_request'
	uses: ./.github/actions/terraform-plan-pr-comment
	with:
		github_token: ${{ github.token }}
		plan_output: ${{ steps.show_plan.outputs.plan_summary }}
		working_directory: terraform/gh-action-examples/deploy-sub-scope
~~~

## Notes

- If no resource operations are detected and Terraform reports no changes, output is:
	- No changes. Infrastructure is up-to-date.
- If Terraform output cannot be summarized into operation lines, a fallback message is returned.
