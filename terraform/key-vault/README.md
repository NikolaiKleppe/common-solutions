## Azure Key Vault

This Terraform stack creates:

- An Azure resource group
- An Azure Key Vault with RBAC enabled
- A role assignment that grants the identity running Terraform the `Key Vault Administrator` role at the vault scope

## Requirements

- Terraform `>= 1.5.0`
- Authenticated Azure CLI session, managed identity, or service principal that the `azurerm` provider can use
- Permission to create resource groups, Key Vaults, and RBAC role assignments

## Usage

Example `terraform.tfvars`:

```hcl
resource_group_name = "rg-platform-shared"
location            = "eastus"
key_vault_name      = "kv-platform-shared-001"

tags = {
	environment = "shared"
	workload    = "github-bootstrap"
}
```

Run:

```powershell
terraform init
terraform plan
terraform apply
```

## Notes

- `rbac_authorization_enabled = true` disables legacy access policies and uses Azure RBAC instead.
- The role assignment uses `data.azurerm_client_config.current.object_id`, which resolves to the current authenticated principal. When Terraform runs under a service principal, that service principal receives `Key Vault Administrator`.
