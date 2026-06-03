resource "azurerm_resource_group" "example" {
  name     = "rg-example-deploy-sub-scope"
  location = "West Europe"
}

resource "azurerm_resource_group" "example-2" {
  name     = "rg-example-deploy-sub-scope-2"
  location = "West Europe"
}