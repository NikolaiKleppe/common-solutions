variable "subscription_id" {
  description = "Azure subscription ID used for the deployment."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "subscription_id must be a valid Azure subscription GUID."
  }
}

variable "location" {
  description = "Azure region for the state management resources."
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the resource group that will host the state storage account."
  type        = string
}

variable "storage_account_name_prefix" {
  description = "Prefix used to build the storage account name. Terraform appends a random suffix to ensure global uniqueness."
  type        = string
  default     = "tfstate"

  validation {
    condition     = can(regex("^[a-z0-9]{3,16}$", var.storage_account_name_prefix))
    error_message = "storage_account_name_prefix must be 3-16 characters, lowercase letters and numbers only."
  }
}

variable "container_name" {
  description = "Blob container name used to store Terraform state files."
  type        = string
  default     = "tfstate"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,63}$", var.container_name))
    error_message = "container_name must be 3-63 characters using lowercase letters, numbers, and hyphens only."
  }
}

variable "tags" {
  description = "Tags applied to deployed resources."
  type        = map(string)
  default     = {}
}