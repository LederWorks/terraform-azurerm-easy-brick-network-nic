################################ NIC
output "nic_interface_list" {
  value       = local.nic_all_interface
  description = "A list of all interfaces."
}
output "nic_default_interface" {
  value       = local.nic_default_interface
  description = "FOR TROUBLESHOOTING"
}
output "nic_additional_interface" {
  value       = local.nic_default_interface
  description = "FOR TROUBLESHOOTING"
}
################################ NSG
output "nic_nsg_association" {
  value       = local.nic_nsg_association
  description = "A list of all nsg associations."
}
output "nic_default_nsg_association" {
  value       = local.nic_default_nsg_association
  description = "FOR TROUBLESHOOTING"
}
output "nic_additional_nsg_association" {
  value       = local.nic_additional_nsg_association
  description = "FOR TROUBLESHOOTING"
}
################################ ASG
output "nic_asg_association" {
  value       = local.nic_asg_association
  description = "A list of all asg associations."
}
output "nic_default_asg_association" {
  value       = local.nic_default_asg_association
  description = "FOR TROUBLESHOOTING"
}
output "nic_additional_asg_association" {
  value       = local.nic_additional_asg_association
  description = "FOR TROUBLESHOOTING"
}