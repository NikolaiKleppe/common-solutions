terraform {
  backend "azurerm" {
    resource_group_name  = "rg-common-solutions-tfstate"
    storage_account_name = "tfstatecommontc7iagly"
    container_name       = "tfstate"
    key                  = "github/common-solutions/github_config.tfstate"
  }
}