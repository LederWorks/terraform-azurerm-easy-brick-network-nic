################################ Providers
provider "azurerm" {
  # tenant_id       = "00000000-0000-0000-0000-000000000000"
  # client_id       = "00000000-0000-0000-0000-000000000000"
  # subscription_id = "00000000-0000-0000-0000-000000000000"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    # virtual_machine {
    #   delete_os_disk_on_deletion     = true
    #   graceful_shutdown              = false
    #   skip_shutdown_and_force_delete = false
    # }

    # virtual_machine_scale_set {
    #   force_delete = true
    #   roll_instances_when_required = true
    #   scale_to_zero_before_deletion = false
    # }

    # key_vault {
    #   purge_soft_delete_on_destroy = true
    #   recover_soft_deleted_key_vaults = false
    # }

  }
}

################################ Terraform
terraform {
  required_version = ">=1.3.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
  backend "azurerm" {
    # tenant_id            = "00000000-0000-0000-0000-000000000000"
    # subscription_id      = "00000000-0000-0000-0000-000000000000"
    resource_group_name  = "rgrp-pde3-it-terratest"
    storage_account_name = "saccpde3itterratest001"
    container_name       = "terratest-azurerm"
    key                  = "terratest-azurerm-easy-brick-network-nic"
    snapshot             = true
  }
}

################################ Client Config Current
data "azurerm_client_config" "current" {
}