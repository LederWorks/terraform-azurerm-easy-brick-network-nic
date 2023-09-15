################################ Outputs
################################ auth
output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

################################ rgrp
output "resource_group_name" {
  value = azurerm_resource_group.RGRP.name
}

################################ NIC list
output "nic_interface_list" {
  value = module.terratest-network-nic.nic_interface_list
}
output "nic_default_interface" {
  value = module.terratest-network-nic.nic_default_interface
}
output "nic_additional_interface" {
  value = module.terratest-network-nic.nic_additional_interface
}

################################ NSG Associations
output "nic_nsg_association" {
  value = module.terratest-network-nic.nic_nsg_association
}
output "nic_default_nsg_association" {
  value = module.terratest-network-nic.nic_default_nsg_association
}
output "nic_additional_nsg_association" {
  value = module.terratest-network-nic.nic_additional_nsg_association
}

################################ ASG Associations
output "nic_asg_association" {
  value = module.terratest-network-nic.nic_asg_association
}
output "nic_default_asg_association" {
  value = module.terratest-network-nic.nic_asg_association
}
output "nic_additional_asg_association" {
  value = module.terratest-network-nic.nic_asg_association
}