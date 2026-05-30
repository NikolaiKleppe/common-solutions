output "resource_group_id" {
  description = "Resource ID of the created resource group."
  value       = azurerm_resource_group.this.id
}

output "resource_group_name" {
  description = "Name of the created resource group."
  value       = azurerm_resource_group.this.name
}

output "managed_identity_id" {
  description = "Resource ID of the managed identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "managed_identity_client_id" {
  description = "Client ID of the managed identity."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "managed_identity_principal_id" {
  description = "Principal ID of the managed identity."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "federated_credential_id" {
  description = "Resource ID of the federated identity credential."
  value       = azurerm_federated_identity_credential.this.id
}

output "service_connection_id" {
  description = "Azure DevOps ARM service connection ID."
  value       = azuredevops_serviceendpoint_azurerm.this.id
}

output "effective_scope" {
  description = "Effective scope used for RBAC and service connection."
  value       = local.effective_scope
}
