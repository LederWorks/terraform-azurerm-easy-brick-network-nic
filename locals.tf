locals {
  ################################ Tags
  tags = merge(
    var.tags,
    {
      creation_mode                            = "terraform"
      terraform-azurerm-easy-brick-network-nic = "True"
    }
  )

  ################################ NICs
  nic_default_interface = var.nic_default_interface != null ? {
    "${azurerm_network_interface.default_interface["nic"].name}" = {
      name = azurerm_network_interface.default_interface["nic"].name,
      id   = azurerm_network_interface.default_interface["nic"].id,
      ip_config = { for v in azurerm_network_interface.default_interface["nic"].ip_configuration :
        v.name => {
          primary : v.primary
          name : v.name,
          private_ip : v.private_ip_address,
          public_ip_id : v.public_ip_address_id
        }
      }
    }
  } : null

  nic_additional_interface = var.nic_additional_interface != null ? {
    for o in azurerm_network_interface.additional_interface :
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
  } : null

  nic_all_interface = merge(local.nic_default_interface, local.nic_additional_interface)

  ################################ NSG Association
  nic_default_nsg_association = var.nic_default_interface != null ? {
    for iface in [var.nic_default_interface] :
    iface.name => {
      network_security_group_id = iface.network_security_group_id
    }
  } : null

  nic_additional_nsg_association = var.nic_additional_interface != null ? {
    for iface in var.nic_additional_interface :
    iface.name => {
      network_security_group_id = iface.network_security_group_id
    }
  } : null

  nic_nsg_association = merge(
    local.nic_default_nsg_association,
    local.nic_additional_nsg_association
  )

  ################################ ASG Association
  nic_default_asg_association = var.nic_default_interface != null ? {
    for asg in coalesce(var.nic_default_interface.application_security_group_ids, []):
    "${var.nic_default_interface.name}-${asg}" => {
      name                          = var.nic_default_interface.name
      application_security_group_id = asg
    }
  } : null

  nic_additional_asg_association = var.nic_additional_interface != null ? merge([
    for iface in var.nic_additional_interface :
    iface.application_security_group_ids == null ? {} : {
      for asg in iface.application_security_group_ids :
      "${iface.name}-${asg}" => {
        name                          = iface.name
        application_security_group_id = asg
      }
    }
  ]...) : null

  nic_asg_association = merge(
    local.nic_default_asg_association,
    local.nic_additional_asg_association
  )

}