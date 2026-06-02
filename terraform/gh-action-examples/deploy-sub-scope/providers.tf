terraform {
  required_version = ">= 1.15.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
  }
}

provider "azurerm" {
  features {}
  # subscription_id = var.azure_subscription_id
}

terraform {
  backend "azurerm" {}
}