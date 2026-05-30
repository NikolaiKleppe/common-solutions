data "azurerm_client_config" "current" {}

data "azuredevops_project" "this" {
  name = var.azure_devops_project_name
}

data "azurerm_subscription" "this" {
  count           = local.scope_type == "subscription" && var.subscription_name == null ? 1 : 0
  subscription_id = var.subscription_id
}

locals {
  scope_type = lower(var.scope_type)

  effective_scope = (
    local.scope_type == "subscription"
    ? "/subscriptions/${var.subscription_id}"
    : "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  )

  role_assignment_map = {
    for idx, assignment in var.role_assignments :
    format("%02d", idx) => assignment
  }

  workload_identity_subject = format(
    "sc://%s/%s/%s",
    var.azure_devops_organization_name,
    var.azure_devops_project_name,
    var.service_connection_name
  )

  subscription_name_effective = var.subscription_name != null ? var.subscription_name : data.azurerm_subscription.this[0].display_name
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_user_assigned_identity" "this" {
  name                = var.managed_identity_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignment_map

  scope                = local.effective_scope
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  principal_type       = "ServicePrincipal"
  role_definition_id   = try(each.value.role_definition_id, null)
  role_definition_name = try(each.value.role_definition_name, null)
}

resource "azurerm_federated_identity_credential" "this" {
  name                = "${var.service_connection_name}-fic"
  resource_group_name = azurerm_resource_group.this.name
  parent_id           = azurerm_user_assigned_identity.this.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://vstoken.dev.azure.com/${var.azure_devops_organization_id}"
  subject             = local.workload_identity_subject
}

resource "time_sleep" "federation_propagation" {
  create_duration = "${var.propagation_delay_seconds}s"

  depends_on = [azurerm_federated_identity_credential.this]
}

resource "azuredevops_serviceendpoint_azurerm" "this" {
  project_id                             = data.azuredevops_project.this.id
  service_endpoint_name                  = var.service_connection_name
  description                            = var.service_connection_description
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"
  credentials {
    serviceprincipalid = azurerm_user_assigned_identity.this.client_id
  }

  azurerm_spn_tenantid          = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id       = local.scope_type == "subscription" ? var.subscription_id : null
  azurerm_subscription_name     = local.scope_type == "subscription" ? local.subscription_name_effective : null
  azurerm_management_group_id   = local.scope_type == "management_group" ? var.management_group_id : null
  azurerm_management_group_name = local.scope_type == "management_group" ? coalesce(var.management_group_name, var.management_group_id) : null

  depends_on = [
    azurerm_role_assignment.this,
    time_sleep.federation_propagation
  ]
}

check "subscription_scope_inputs" {
  assert {
    condition     = local.scope_type != "subscription" || (var.subscription_id != null && length(var.subscription_id) > 0)
    error_message = "subscription_id is required when scope_type is subscription."
  }
}

check "management_group_scope_inputs" {
  assert {
    condition     = local.scope_type != "management_group" || (var.management_group_id != null && length(var.management_group_id) > 0)
    error_message = "management_group_id is required when scope_type is management_group."
  }
}
