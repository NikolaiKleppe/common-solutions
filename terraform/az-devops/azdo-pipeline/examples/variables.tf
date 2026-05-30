
variable "azure_devops_pat" {
  description = "Azure DevOps PAT with permissions to manage service connections."
  type        = string
  sensitive   = true
}

variable "azure_devops_project_name" {
  description = "Azure DevOps project name where the service connection will be created."
  type        = string
}

variable "azure_devops_organization_name" {
  description = "Azure DevOps organization name from https://dev.azure.com/<organization>."
  type        = string
}

variable "azure_devops_organization_id" {
  description = "Azure DevOps organization GUID used in the OIDC issuer URL."
  type        = string
}

variable "service_connection_name" {
  description = "Name of the Azure DevOps ARM service connection."
  type        = string
}

variable "service_connection_description" {
  description = "Description for the Azure DevOps ARM service connection."
  type        = string
}

variable "scope_type" {
  description = "Scope for service connection and RBAC assignments: subscription or management_group."
  type        = string
}

variable "subscription_id" {
  description = "Target Azure subscription ID. Use null for management_group scope."
  type        = string
  default     = null
}

variable "subscription_name" {
  description = "Friendly Azure subscription name. Use null for management_group scope."
  type        = string
  default     = null
}

variable "management_group_id" {
  description = "Management group ID. Use null for subscription scope."
  type        = string
  default     = null
}

variable "management_group_name" {
  description = "Management group display name. Use null for subscription scope."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region for the resource group and managed identity."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the new resource group to create for the managed identity."
  type        = string
}

variable "managed_identity_name" {
  description = "Name of the user-assigned managed identity."
  type        = string
}

variable "role_assignments" {
  description = "RBAC assignments for the managed identity."
  type = list(object({
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
  }))
}

variable "propagation_delay_seconds" {
  description = "Delay after federated credential creation to reduce propagation race conditions."
  type        = number
}

variable "tags" {
  description = "Tags applied to Azure resources."
  type        = map(string)
}