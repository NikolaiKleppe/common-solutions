## Terraform State Management

This folder provisions the Azure resources required to host Terraform remote state:

- Resource group
- Storage account
- Private blob container

The storage account name is derived from `storage_account_name_prefix` plus a random suffix so the final name is globally unique.

## Files

- `versions.tf`: Terraform and provider requirements
- `variables.tf`: Input variables and validation rules
- `main.tf`: Azure resources
- `outputs.tf`: Deployment outputs
- `terraform.tfvars`: Deployment values for the target subscription

## Deployment

Authenticate with Azure and select the target subscription:

```powershell
az login
az account set --subscription c33f9068-3058-4127-a12d-d44382efa830
```

Initialize and apply the deployment:

```powershell
terraform init
terraform plan
terraform apply
```

After apply completes, use the output values to configure a Terraform backend, for example:

```hcl
terraform {
	backend "azurerm" {
		resource_group_name  = "rg-common-solutions-tfstate"
		storage_account_name = "<output storage_account_name>"
		container_name       = "tfstate"
		key                  = "platform.tfstate"
	}
}
```
