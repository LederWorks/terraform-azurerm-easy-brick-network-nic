################################ Resource Group
resource "azurerm_resource_group" "network-nic" {
  name     = "network-nic"
  location = "East US 2"
  tags     = local.tags
}

################################ Public IPs
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

################################ NIC Module
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
    name                           = "vnic-001"
    subnet_id                      = ""
    dns_servers                    = ["4.4.4.4", "8.8.8.8"]
    edge_zone                      = ""
    ip_forwarding_enabled          = true
    accelerated_networking_enabled = true
    internal_dns_name_label        = ""

    ip_config = [
      #default-primary
      {
        name                  = "default-primary"
        private_ip_allocation = "Static"
        private_ip_address    = "192.168.169.170"
        primary               = true
      },
      #default-public
      {
        name         = "default-public"
        public_ip_id = azurerm_public_ip.public-ip1.id
      }
    ]
  }

  ###############################
  #### Additional Interfaces ####
  ###############################

  nic_additional_interface = [

    #vnic-002
    {
      name                           = "vnic-002"
      subnet_id                      = ""
      dns_servers                    = ["4.4.4.4", "8.8.8.8"]
      edge_zone                      = ""
      ip_forwarding_enabled          = true
      accelerated_networking_enabled = true
      internal_dns_name_label        = ""
      ip_config = [
        #primary
        {
          name    = "primary"
          private_ip_allocation = "Static"
          private_ip_address    = "192.168.169.171"
          primary = true
        },
        #public
        {
          name         = "public"
          public_ip_id = azurerm_public_ip.public-ip2.id
        }
      ]
    },
    #vnic-003
    {
      name = "vnic-003"
      ip_config = [
        #primary
        {
          name    = "primary"
          primary = true
        },
        #public
        {
          name         = "public"
          public_ip_id = azurerm_public_ip.public-ip3.id
        }
      ]
    }
  ]
  
}

################################ Outputs
output "nic_interface_list" {
  value = module.network-nic.nic_interface_list
}
output "nic_nsg_association" {
  value = module.network-nic.nic_nsg_association
}
output "nic_asg_association" {
  value = module.network-nic.nic_asg_association
}