terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.15.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "{insert-subscription-id}"
  features {}

  resource_provider_registrations = "extended"
  resource_providers_to_register  = ["Microsoft.DevCenter", "microsoft.devopsinfrastructure"]
}

provider "azapi" {}
