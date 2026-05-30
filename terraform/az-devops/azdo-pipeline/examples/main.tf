terraform {
  required_version = ">= 1.15.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/${var.azure_devops_organization_name}"
  personal_access_token = var.azure_devops_pat
}


module "azdo_pipeline_connection" {
  source = "../"

  azure_devops_project_name      = var.azure_devops_project_name
  azure_devops_organization_name = var.azure_devops_organization_name
  azure_devops_organization_id   = var.azure_devops_organization_id

  service_connection_name        = var.service_connection_name
  service_connection_description = var.service_connection_description

  scope_type            = var.scope_type
  subscription_id       = var.subscription_id
  subscription_name     = var.subscription_name
  management_group_id   = var.management_group_id
  management_group_name = var.management_group_name

  resource_group_name   = var.resource_group_name
  managed_identity_name = var.managed_identity_name
  location              = var.location

  role_assignments          = var.role_assignments
  propagation_delay_seconds = var.propagation_delay_seconds
  tags                      = var.tags
}
