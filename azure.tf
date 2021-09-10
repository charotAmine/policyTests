terraform {
  required_version = ">=1.0"
  backend "azurerm" {
    resource_group_name  = "default-rg"
    storage_account_name = "tfstate01234"
    container_name       = "tfstate"
    key                  = "policy.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.67.0"
    }
  }
}

provider "azurerm" {
  features {}
}