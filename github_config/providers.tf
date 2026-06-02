provider "github" {
  owner = var.github_owner
}

provider "azuread" {}

provider "azurerm" {
  features {}
}