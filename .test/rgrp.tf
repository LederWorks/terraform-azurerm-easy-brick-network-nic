################################ Resource Group
resource "azurerm_resource_group" "rgrp-tde3-it-terratest-network-nic" {
  name     = "rgrp-tde3-it-terratest-network-nic"
  location = "Germany West Central"
  tags     = local.tags
}