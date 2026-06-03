variable "management_group_id" {
	description = "Management group id"
	type        = string
}

resource "azurerm_management_group_policy_assignment" "apim_secret_named_values_audit" {
	name                 = "gh-action-apim-secret"
	display_name         = "gh-action-examples-API Management secret named values should be stored in Azure Key Vault"
	description          = "Example assignment of a built-in policy definition at management group scope in Audit mode."
	management_group_id  = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
	policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f1cc7827-022c-473e-836e-5a51cae0b249"

	parameters = jsonencode({
		effect = {
			value = "Audit"
		}
	})
}
