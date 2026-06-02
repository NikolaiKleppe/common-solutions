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



