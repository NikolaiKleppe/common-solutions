resource "github_actions_secret" "azure_client_id" {
	repository      = var.repository_name
	secret_name     = "AZURE_CLIENT_ID"
	value           = azuread_application.gh_actions.client_id
}

resource "github_actions_secret" "azure_tenant_id" {
	repository      = var.repository_name
	secret_name     = "AZURE_TENANT_ID"
	value           = var.azure_tenant_id
}

resource "github_actions_variable" "azure_subscription_id" {
	count = var.azure_subscription_id == "" ? 0 : 1

	repository    = var.repository_name
	variable_name = "AZURE_SUBSCRIPTION_ID"
	value         = var.azure_subscription_id
}

resource "github_actions_variable" "tfstate_subscription_id" {
	repository    = var.repository_name
	variable_name = "TFSTATE_SUBSCRIPTION_ID"
	value         = var.tfstate_subscription_id
}




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
  claims_matching_expression = "claims['sub'] matches 'repo:${var.github_owner}/${var.repository_name}:ref:refs/heads/*'"
}

# Assign Contributor role to service principal on the subscription
resource "azurerm_role_assignment" "sp_contributor" {
	count              = var.azure_subscription_id == "" ? 0 : 1
	scope              = "/subscriptions/${var.azure_subscription_id}"
  role_definition_name = "Contributor"
  principal_id       = azuread_service_principal.gh_actions.object_id
}

