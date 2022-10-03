output "nic_interface_list" {
  value = merge(local.nic_default_interface, local.nic_additional_interface)
}