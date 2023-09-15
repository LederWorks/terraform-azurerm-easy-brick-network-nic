################################ Network Security Groups
# resource "azurerm_network_interface_security_group_association" "nsg_association" {
#   for_each = local.nic_nsg_association != null ? local.nic_nsg_association : null

#   network_interface_id      = local.nic_all_interface[each.key].id
#   network_security_group_id = each.value.network_security_group_id
# }

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each = { for key, value in local.nic_nsg_association : key => value if value.network_security_group_id != null }

  network_interface_id      = local.nic_all_interface[each.key].id
  network_security_group_id = each.value.network_security_group_id
}


################################ Application Security Groups
# resource "azurerm_network_interface_application_security_group_association" "asg_association" {
#   for_each = local.nic_asg_association != null ? local.nic_asg_association : null

#   network_interface_id          = local.nic_all_interface[each.value.name].id
#   application_security_group_id = each.value.application_security_group_id
# }

resource "azurerm_network_interface_application_security_group_association" "asg_association" {
  for_each = { for key, value in local.nic_asg_association : key => value if value.application_security_group_id != null }

  network_interface_id          = local.nic_all_interface[each.value.name].id
  application_security_group_id = each.value.application_security_group_id

  # depends_on = [
  #   azurerm_network_interface.default_interface,    # Add dependencies here if needed
  #   azurerm_network_interface.additional_interface, # Add dependencies here if needed
  # ]
}
