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
  nic_subnet_id   = azurerm_subnet.network-nic001.id
  nic_dns_servers = ["4.4.4.4", "8.8.8.8"]

  #Local Variables
  nic_default_interface = {
    name                           = "vnic-001"
    subnet_id                      = ""
    dns_servers                    = []
    edge_zone                      = ""
    ip_forwarding_enabled          = true
    accelerated_networking_enabled = true
    internal_dns_name_label        = ""
    network_security_group_id      = ""
    application_security_group_ids = [
      azurerm_application_security_group.network-nic001.id,
      azurerm_application_security_group.network-nic002.id
    ]

    ip_config = [
      {
        name                  = "default-primary"
        private_ip_allocation = "Static"
        private_ip_address    = "192.168.169.170"
        primary               = true
      },
      {
        name         = "default-public"
        public_ip_id = azurerm_public_ip.public-ip1.id
      }
    ]

  }

  nic_additional_interface = [
    {
      name                           = "vnic-002"
      subnet_id                      = azurerm_subnet.network-nic002.id
      dns_servers                    = ["1.1.1.1", "1.0.0.1"]
      edge_zone                      = ""
      ip_forwarding_enabled          = true
      accelerated_networking_enabled = true
      internal_dns_name_label        = ""
      network_security_group_id      = azurerm_network_security_group.network-nic.id
      application_security_group_ids = [
        azurerm_application_security_group.network-nic001.id,
        azurerm_application_security_group.network-nic003.id
      ]
      ip_config = [
        {
          name                  = "primary"
          private_ip_allocation = "Static"
          private_ip_address    = "192.168.169.171"
          primary               = true
        },
        {
          name         = "public"
          public_ip_id = azurerm_public_ip.public-ip2.id
        }
      ]
    },
    #vnic-003
    {
      name                      = "vnic-003"
      subnet_id                 = azurerm_subnet.network-nic003.id
      network_security_group_id = azurerm_network_security_group.network-nic.id
      application_security_group_ids = [
        azurerm_application_security_group.network-nic002.id,
        azurerm_application_security_group.network-nic003.id
      ]
    }
  ]

}

output "nic_interface_list" {
  value = module.network-nic.nic_interface_list
}
output "nic_nsg_association" {
  value = module.network-nic.nic_nsg_association
}
output "nic_asg_association" {
  value = module.network-nic.nic_asg_association
}
