module "network-nic" {
  source  = "LederWorks/easy-brick-network-nic/azurerm"
  version = "X.X.X"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.example

  #Tags
  tags = local.tags

  #Global Variables
  nic_subnet_id   = azurerm_subnet.example.id
  nic_dns_servers = ["4.4.4.4", "8.8.8.8"]

  #Local Variables
  nic_default_interface = {
    name = "vnic-001"
  }
}