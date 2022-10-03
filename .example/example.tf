#Resource Group
resource "azurerm_resource_group" "network-nic" {
  name     = "network-nic"
  location = "East US 2"
  tags     = local.tags
}

#Public IPs
resource "azurerm_public_ip" "public-ip1" {
  name                = "public-ip1"
  resource_group_name = azurerm_resource_group.network-nic.name
  location            = azurerm_resource_group.network-nic.location
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "public-ip2" {
  name                = "public-ip2"
  resource_group_name = azurerm_resource_group.network-nic.name
  location            = azurerm_resource_group.network-nic.location
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "public-ip3" {
  name                = "public-ip3"
  resource_group_name = azurerm_resource_group.network-nic.name
  location            = azurerm_resource_group.network-nic.location
  allocation_method   = "Static"
}

#NIC Module
module "network-nic" {
  source  = "LederWorks/easy-brick-network-nic/azurerm"
  version = "X.X.X"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.network-nic

  #Tags
  tags = local.tags

  #Global Variables
  nic_subnet_id = ""

  #Variables

  ###########################
  #### Default Interface ####
  ###########################

  nic_default_interface = {
    nic_name                           = "vnic-001"
    nic_subnet_id                      = ""
    nic_dns_servers                    = ["4.4.4.4", "8.8.8.8"]
    nic_edge_zone                      = ""
    nic_ip_forwarding_enabled          = true
    nic_accelerated_networking_enabled = true
    nic_internal_dns_name_label        = ""

    nic_ip_config = [
      #default-primary
      {
        nic_ip_config_name                  = "default-primary"
        nic_ip_config_private_ip_allocation = "Static"
        nic_ip_config_private_ip_address    = "192.168.169.170"
        nic_ip_config_primary               = true
      },
      #default-public
      {
        nic_ip_config_name         = "default-public"
        nic_ip_config_public_ip_id = azurerm_public_ip.public-ip1.id
      }
    ]
  }

  ###############################
  #### Additional Interfaces ####
  ###############################

  nic_additional_interface = [

    #vnic-002
    {
      nic_name                           = "vnic-002"
      nic_subnet_id                      = ""
      nic_dns_servers                    = ["4.4.4.4", "8.8.8.8"]
      nic_edge_zone                      = ""
      nic_ip_forwarding_enabled          = true
      nic_accelerated_networking_enabled = true
      nic_internal_dns_name_label        = ""
      nic_ip_config = [
        #primary
        {
          nic_ip_config_name    = "primary"
          nic_ip_config_private_ip_allocation = "Static"
          nic_ip_config_private_ip_address    = "192.168.169.171"
          nic_ip_config_primary = true
        },
        #public
        {
          nic_ip_config_name         = "public"
          nic_ip_config_public_ip_id = azurerm_public_ip.public-ip2.id
        }
      ]
    },
    #vnic-003
    {
      nic_name = "vnic-003"
      nic_ip_config = [
        #primary
        {
          nic_ip_config_name    = "primary"
          nic_ip_config_primary = true
        },
        #public
        {
          nic_ip_config_name         = "public"
          nic_ip_config_public_ip_id = azurerm_public_ip.public-ip3.id
        }
      ]
    }
  ]


}

#Outputs
#auth
output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

#rgrp
output "resource_group_name" {
  value = azurerm_resource_group.network-nic.name
}

#nic
output "nic_interface_list" {
  value = module.network-nic.nic_interface_list
}