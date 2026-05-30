variable "azure_devops_project_name" {
  description = "Azure DevOps project name where the service connection will be created."
  type        = string
}

variable "azure_devops_organization_name" {
  description = "Azure DevOps organization name from https://dev.azure.com/<organization>."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{1,49}$", var.azure_devops_organization_name))
    error_message = "azure_devops_organization_name must contain letters, numbers, and hyphens."
  }
}

variable "azure_devops_organization_id" {
  description = "Azure DevOps organization GUID used in the OIDC issuer URL."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.azure_devops_organization_id))
    error_message = "azure_devops_organization_id must be a valid GUID."
  }
}

variable "service_connection_name" {
  description = "Name of the Azure DevOps ARM service connection."
  type        = string
}

variable "service_connection_description" {
  description = "Description for the Azure DevOps ARM service connection."
  type        = string
  default     = "Managed by Terraform"
}

variable "scope_type" {
  description = "Scope for service connection and RBAC assignments: subscription or management_group."
  type        = string

  validation {
    condition     = contains(["subscription", "management_group"], lower(var.scope_type))
    error_message = "scope_type must be either subscription or management_group."
  }
}

variable "subscription_id" {
  description = "Target Azure subscription ID. Required when scope_type is subscription."
  type        = string
  default     = null

  validation {
    condition     = var.subscription_id == null || can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "subscription_id must be null or a valid Azure subscription GUID."
  }
}

variable "subscription_name" {
  description = "Friendly Azure subscription name shown in Azure DevOps. Optional when scope_type is subscription."
  type        = string
  default     = null
}

variable "management_group_id" {
  description = "Management group ID (not display name). Required when scope_type is management_group."
  type        = string
  default     = null
}

variable "management_group_name" {
  description = "Management group display name shown in Azure DevOps. Optional when scope_type is management_group."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region for the resource group and managed identity."
  type        = string
  default     = "westeurope"
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
  description = "RBAC assignments for the managed identity. Provide role_definition_name or role_definition_id per item."
  type = list(object({
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
  }))

  validation {
    condition = alltrue([
      for assignment in var.role_assignments :
      try(assignment.role_definition_name, null) != null || try(assignment.role_definition_id, null) != null
    ])
    error_message = "Each role assignment must include role_definition_name or role_definition_id."
  }
}

variable "propagation_delay_seconds" {
  description = "Delay after federated credential creation to reduce propagation race conditions."
  type        = number
  default     = 30

  validation {
    condition     = var.propagation_delay_seconds >= 0 && var.propagation_delay_seconds <= 300
    error_message = "propagation_delay_seconds must be between 0 and 300."
  }
}

variable "tags" {
  description = "Tags applied to Azure resources."
  type        = map(string)
  default     = {}
}
