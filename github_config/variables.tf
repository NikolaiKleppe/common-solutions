variable "github_owner" {
  description = "GitHub owner (organization or user) that contains the target repository."
  type        = string
}

variable "repository_name" {
  description = "Target repository name where Actions secrets and variables will be created."
  type        = string
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

variable "management_group_id" {
  description = "Optional management group resource ID scope for role assignment, for example /providers/Microsoft.Management/managementGroups/contoso-platform."
  type        = string
  default     = ""
}

variable "tfstate_subscription_id" {
  description = "Value for the TFSTATE_SUBSCRIPTION_ID GitHub Actions variable used by backend configuration."
  type        = string
}

variable "service_principal_display_name" {
  description = "Display name for the Azure AD service principal that will be created."
  type        = string
}

variable "apply_environment_name" {
  description = "GitHub Actions environment name used to gate Terraform apply."
  type        = string
  default     = "terraform-apply"
}

variable "apply_environment_reviewer_usernames" {
  description = "GitHub usernames allowed to approve the Terraform apply environment."
  type        = list(string)
  default     = []
}

variable "apply_environment_reviewer_team_slugs" {
  description = "GitHub team slugs allowed to approve the Terraform apply environment."
  type        = list(string)
  default     = []
}