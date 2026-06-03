
# Create Azure AD Application (App Registration)
resource "azuread_application" "gh_actions" {
  display_name = var.service_principal_display_name
}

# Create Service Principal for the application
resource "azuread_service_principal" "gh_actions" {
  client_id = azuread_application.gh_actions.client_id
}

# Configure OIDC federated credentials for GitHub (all branches)
resource "azuread_application_flexible_federated_identity_credential" "gh_actions" {
  application_id = azuread_application.gh_actions.id
	display_name   = "github-actions-all-branches"
  audience       = "api://AzureADTokenExchange"
  issuer         = "https://token.actions.githubusercontent.com"
  # claims_matching_expression = "claims['sub'] matches 'repo:${var.github_owner}/${var.repository_name}:ref:refs/heads/*'"
  claims_matching_expression = "claims['sub'] matches 'repo:${var.github_owner}/${var.repository_name}:*'" # NOTE: This is a workaround to allow all branches AND environments to authenticate. Implement more restrictive expressions if needed.
}

# Assign Contributor role to service principal on the subscription
resource "azurerm_role_assignment" "sp_contributor" {
	count              = var.azure_subscription_id == "" ? 0 : 1
	scope              = "/subscriptions/${var.azure_subscription_id}"
  role_definition_name = "Contributor"
  principal_id       = azuread_service_principal.gh_actions.object_id
}

resource "azurerm_role_assignment" "sp_contributor_management_group" {
  count                = var.management_group_id == "" ? 0 : 1
  scope                = var.management_group_id
  role_definition_name = "Resource Policy Contributor"
  principal_id         = azuread_service_principal.gh_actions.object_id
}


