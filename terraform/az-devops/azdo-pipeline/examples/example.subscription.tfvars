# Full example values for subscription-scope deployment.
# Update all placeholder values before running terraform plan/apply.

azure_devops_project_name      = "platform-project"
azure_devops_organization_name = "contoso-platform"
azure_devops_organization_id   = "00000000-0000-0000-0000-000000000000"

service_connection_name        = "sc-arm-wif-platform"
service_connection_description = "ARM service connection backed by managed identity and OIDC"

scope_type        = "subscription"
subscription_id   = "11111111-1111-1111-1111-111111111111"
subscription_name = "Contoso Platform Subscription"

# Leave management group fields null for subscription scope.
management_group_id   = null
management_group_name = null

location              = "westeurope"
resource_group_name   = "rg-azdo-id-platform-weu"
managed_identity_name = "id-azdo-sc-platform"

role_assignments = [
  {
    role_definition_name = "Reader"
  },
  {
    role_definition_name = "Contributor"
  }
  # Example using role_definition_id instead of name:
  # {
  #   role_definition_id = "/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Authorization/roleDefinitions/<role-guid>"
  # }
]

propagation_delay_seconds = 45

tags = {
  managed_by  = "terraform"
  environment = "platform"
  workload    = "azure-devops"
}
