################################ Create Network
resource "azurerm_virtual_network" "vnet-tde3-it-terratest-network-nic" {
  name = "vnet-tde3-it-terratest-network-nic"
  resource_group_name = azurerm_resource_group.rgrp-tde3-it-terratest-network-nic.name
  location = azurerm_resource_group.rgrp-tde3-it-terratest-network-nic.location
  tags = local.tags
  address_space = [ "10.0.0.0/16" ]
}
resource "azurerm_subnet" "snet-tde3-it-terratest-network-nic001" {
  name = "snet-tde3-it-terratest-network-nic001"
  resource_group_name = azurerm_resource_group.rgrp-tde3-it-terratest-network-nic.name
  virtual_network_name = azurerm_virtual_network.vnet-tde3-it-terratest-network-nic.name
  address_prefixes = [ "10.0.0.0/24" ]
}
resource "azurerm_subnet" "snet-tde3-it-terratest-network-nic002" {
  name = "snet-tde3-it-terratest-network-nic002"
  resource_group_name = azurerm_resource_group.rgrp-tde3-it-terratest-network-nic.name
  virtual_network_name = azurerm_virtual_network.vnet-tde3-it-terratest-network-nic.name
  address_prefixes = [ "10.0.1.0/24" ]
}
resource "azurerm_subnet" "snet-tde3-it-terratest-network-nic003" {
  name = "snet-tde3-it-terratest-network-nic003"
  resource_group_name = azurerm_resource_group.rgrp-tde3-it-terratest-network-nic.name
  virtual_network_name = azurerm_virtual_network.vnet-tde3-it-terratest-network-nic.name
  address_prefixes = [ "10.0.2.0/24" ]
}

################################ Module Test
module "terratest-network-nic" {
  source = "../"

  ### Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  ### Resource Group
  resource_group_object = azurerm_resource_group.rgrp-tde3-it-terratest-network-nic

  ### Tags
  tags = local.tags

  ### Global Variables ###
  nic_subnet_id = azurerm_subnet.snet-tde3-it-terratest-network-nic001.id

  nic_dns_servers = ["4.4.4.4", "8.8.8.8"]

  ### Local Variables ###

  ###########################
  #### Default Interface ####
  ###########################

  nic_default_interface = {
    name                           = "vnic-001"
    ip_forwarding_enabled          = true
    accelerated_networking_enabled = true

    ip_config = [
      #default-primary-static
      {
        name                  = "default-primary"
        private_ip_allocation = "Static"
        private_ip_address    = "10.0.0.10"
        primary               = true
      },
      #default-public
      # {
      #   name         = "default-public"
      #   public_ip_id = azurerm_public_ip.public-ip1.id
      # }
    ]
  }

  ###############################
  #### Additional Interfaces ####
  ###############################

  nic_additional_interface = [

    #vnic-002
    {
      name                           = "vnic-002"
      subnet_id = azurerm_subnet.snet-tde3-it-terratest-network-nic002.id
      # primary               = true
    },
    #vnic-003
    {
      name = "vnic-003"
      subnet_id = azurerm_subnet.snet-tde3-it-terratest-network-nic003.id
      dns_servers = [ "1.1.1.1", "1.0.0.1" ]
      # primary               = true
    }
  ]

}
