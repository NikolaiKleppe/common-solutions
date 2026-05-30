# Full example values for management-group-scope deployment.
# Update all placeholder values before running terraform plan/apply.


azure_devops_project_name      = "platform-project"
azure_devops_organization_name = "contoso-platform"
azure_devops_organization_id   = "00000000-0000-0000-0000-000000000000"

service_connection_name        = "sc-arm-wif-mg-platform"
service_connection_description = "ARM service connection at management group scope via managed identity and OIDC"

scope_type = "management_group"

# Leave subscription fields null for management group scope.
subscription_id   = null
subscription_name = null

management_group_id   = "mg-platform"
management_group_name = "Platform"

location              = "westeurope"
resource_group_name   = "rg-azdo-id-platform-weu"
managed_identity_name = "id-azdo-sc-platform-mg"

role_assignments = [
  {
    role_definition_name = "Reader"
  }
  # Example using role_definition_id instead of name:
  # {
  #   role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/<role-guid>"
  # }
]

propagation_delay_seconds = 45

tags = {
  managed_by  = "terraform"
  environment = "platform"
  workload    = "azure-devops"
}
