################################ Versions
terraform {
  required_version = ">=1.3.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.67.0"
    }
  }
}