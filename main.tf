################################ Default NIC
resource "azurerm_network_interface" "default_interface" {
  for_each = var.nic_default_interface != null ? toset(["nic"]) : toset([])

  resource_group_name = var.resource_group_object.name
  location            = var.resource_group_object.location

  name                          = var.nic_default_interface.name
  dns_servers                   = coalesce(var.nic_default_interface.dns_servers, var.nic_dns_servers)
  edge_zone                     = var.nic_default_interface.edge_zone
  enable_ip_forwarding          = var.nic_default_interface.ip_forwarding_enabled
  enable_accelerated_networking = var.nic_default_interface.accelerated_networking_enabled
  internal_dns_name_label       = var.nic_default_interface.internal_dns_name_label

  dynamic "ip_configuration" {
    for_each = var.nic_default_interface.ip_config != null ? { for el in var.nic_default_interface.ip_config : el.name => el } : {}
    content {
      name                          = ip_configuration.key
      subnet_id                     = coalesce(var.nic_default_interface.subnet_id, var.nic_subnet_id)
      private_ip_address_allocation = ip_configuration.value.private_ip_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = ip_configuration.value.public_ip_id
      primary                       = ip_configuration.value.primary
    }
  }
}

################################ Additional NICs
resource "azurerm_network_interface" "additional_interface" {
  for_each = var.nic_additional_interface != null ? { for obj in var.nic_additional_interface : obj.name => obj } : {}

  resource_group_name = var.resource_group_object.name
  location            = var.resource_group_object.location

  name                          = each.value.name
  dns_servers                   = each.value.dns_servers
  edge_zone                     = each.value.edge_zone
  enable_ip_forwarding          = each.value.ip_forwarding_enabled
  enable_accelerated_networking = each.value.accelerated_networking_enabled
  internal_dns_name_label       = each.value.internal_dns_name_label

  dynamic "ip_configuration" {
    for_each = { for el in each.value.ip_config : el.name => el }
    content {
      name                          = ip_configuration.key
      subnet_id                     = coalesce(each.value.subnet_id, var.nic_subnet_id)
      private_ip_address_allocation = coalesce(ip_configuration.value.private_ip_allocation, "Dynamic")
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = ip_configuration.value.public_ip_id
      primary                       = coalesce(ip_configuration.value.primary, false)
    }
  }
}