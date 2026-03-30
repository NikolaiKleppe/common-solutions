output "resource_group_name" {
  description = "Resource group that hosts the Terraform state storage."
  value       = azurerm_resource_group.state.name
}

output "storage_account_name" {
  description = "Generated storage account name for Terraform state."
  value       = azurerm_storage_account.state.name
}

output "container_name" {
  description = "Blob container name for Terraform state files."
  value       = azurerm_storage_container.state.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint for the storage account."
  value       = azurerm_storage_account.state.primary_blob_endpoint
}