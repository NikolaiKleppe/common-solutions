variable "github_owner" {
  description = "GitHub owner (organization or user) that contains the target repository."
  type        = string
}

variable "repository_name" {
  description = "Target repository name where Actions secrets and variables will be created."
  type        = string
}

variable "azure_client_id" {
  description = "Value for the AZURE_CLIENT_ID GitHub Actions secret."
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Value for the AZURE_TENANT_ID GitHub Actions secret."
  type        = string
  sensitive   = true
}

variable "azure_subscription_id" {
  description = "Optional value for the AZURE_SUBSCRIPTION_ID GitHub Actions variable. Leave empty for management group-only authentication."
  type        = string
  default     = ""
}

variable "tfstate_subscription_id" {
  description = "Value for the TFSTATE_SUBSCRIPTION_ID GitHub Actions variable used by backend configuration."
  type        = string
}