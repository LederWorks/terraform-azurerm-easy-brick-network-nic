locals {
  #Tags
  tags = merge({
    creation_mode                      = "terraform"
    terraform-azurerm-easy-brick-network-nic = "True"
  }, var.tags)

  #NICs
  nic_default_interface = {
    "${azurerm_network_interface.default_interface.name}" = {
      name = azurerm_network_interface.default_interface.name,
      id   = azurerm_network_interface.default_interface.id,
      ip_config = { for v in azurerm_network_interface.default_interface.ip_configuration :
        v.name => {
          primary : v.primary
          name : v.name,
          private_ip : v.private_ip_address,
          public_ip_id : v.public_ip_address_id
        }
      }
    }
  }

  nic_additional_interface = { for o in azurerm_network_interface.additional_interface :
    o.name => {
      name : o.name,
      id : o.id,
      ip_config : { for e in o.ip_configuration :
        e.name => {
          primary : e.primary
          name : e.name,
          private_ip : e.private_ip_address,
          public_ip_id : e.public_ip_address_id
      } }
    }
  }
}