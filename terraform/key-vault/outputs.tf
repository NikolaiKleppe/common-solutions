output "resource_group_name" {
  description = "Resource group containing the Key Vault."
  value       = azurerm_resource_group.this.name
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault."
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.this.name
}

output "current_principal_object_id" {
  description = "Object ID of the identity running Terraform that was granted Key Vault Administrator."
  value       = data.azurerm_client_config.current.object_id
}