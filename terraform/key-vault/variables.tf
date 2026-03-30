variable "resource_group_name" {
  description = "Name of the resource group that will contain the Key Vault."
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault."
  type        = string
}

variable "key_vault_name" {
  description = "Globally unique name for the Key Vault."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU name."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], lower(var.sku_name))
    error_message = "sku_name must be either standard or premium."
  }
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled for the Key Vault."
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention in days."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "tags" {
  description = "Tags applied to the Key Vault."
  type        = map(string)
  default     = {}
}