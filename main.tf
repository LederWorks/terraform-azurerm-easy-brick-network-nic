# Default Interface
resource "azurerm_network_interface" "default_interface" {
  resource_group_name = var.resource_group_object.name
  location            = var.resource_group_object.location

  name                          = var.nic_default_interface.nic_name
  dns_servers                   = var.nic_default_interface.nic_dns_servers
  edge_zone                     = var.nic_default_interface.nic_edge_zone
  enable_ip_forwarding          = var.nic_default_interface.nic_ip_forwarding_enabled
  enable_accelerated_networking = var.nic_default_interface.nic_accelerated_networking_enabled
  internal_dns_name_label       = var.nic_default_interface.nic_internal_dns_name_label

  dynamic "ip_configuration" {
    for_each = { for el in var.nic_default_interface.nic_ip_config : el.nic_ip_config_name => el }
    content {
      name                          = ip_configuration.key
      subnet_id                     = coalesce(var.nic_default_interface.nic_subnet_id, var.nic_subnet_id)
      private_ip_address_allocation = coalesce(ip_configuration.value.nic_ip_config_private_ip_allocation, "Dynamic")
      private_ip_address            = ip_configuration.value.nic_ip_config_private_ip_address
      public_ip_address_id          = ip_configuration.value.nic_ip_config_public_ip_id
      primary                       = coalesce(ip_configuration.value.nic_ip_config_primary, false)
    }
  }
}

# Additional Interfaces
resource "azurerm_network_interface" "additional_interface" {
  for_each = var.nic_additional_interface != null ? { for obj in var.nic_additional_interface : obj.nic_name => obj } : {}

  resource_group_name = var.resource_group_object.name
  location            = var.resource_group_object.location

  name                          = each.value.nic_name
  dns_servers                   = each.value.nic_dns_servers
  edge_zone                     = each.value.nic_edge_zone
  enable_ip_forwarding          = each.value.nic_ip_forwarding_enabled
  enable_accelerated_networking = each.value.nic_accelerated_networking_enabled
  internal_dns_name_label       = each.value.nic_internal_dns_name_label

  dynamic "ip_configuration" {
    for_each = { for el in each.value.nic_ip_config : el.nic_ip_config_name => el }
    content {
      name                          = ip_configuration.key
      subnet_id                     = coalesce(each.value.nic_subnet_id, var.nic_subnet_id)
      private_ip_address_allocation = coalesce(ip_configuration.value.nic_ip_config_private_ip_allocation, "Dynamic")
      private_ip_address            = ip_configuration.value.nic_ip_config_private_ip_address
      public_ip_address_id          = ip_configuration.value.nic_ip_config_public_ip_id
      primary                       = coalesce(ip_configuration.value.nic_ip_config_primary, false)
    }
  }
}