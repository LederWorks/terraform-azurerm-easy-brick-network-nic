variable "nic_default_interface" {
  description = <<EOT
    (Required) The default Network Interfaces to be created.

    REQUIRED

    nic_name                            - (Required) The name of the Network Interface. Changing this forces a new resource to be created.
    
    OPTIONAL

    nic_subnet_id                       - (Optional) The ID of the Subnet where this Network Interface should be located in.
    
    nic_dns_servers                     - (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. 
                                          Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.
    
    nic_edge_zone                       - (Optional) Specifies the Edge Zone within the Azure Region where this Network Interface should exist. Changing this forces a new Network Interface to be created.
    
    nic_ip_forwarding_enabled           - (Optional) Should IP Forwarding be enabled? Defaults to false.
    
    nic_accelerated_networking_enabled  - (Optional) Should Accelerated Networking be enabled? Defaults to false. 
                                          Only certain Virtual Machine sizes are supported for Accelerated Networking.
                                          For more information check https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli.
                                          To use Accelerated Networking in an Availability Set, the Availability Set must be deployed onto an Accelerated Networking enabled cluster.
    
    nic_internal_dns_name_label         - (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.
    
    IP CONFIGURATION

    nic_ip_config -  (Required) One or more ip_configuration blocks as defined below.
        nic_ip_config_name                  - (Required) A name used for this IP Configuration.
        nic_ip_config_private_ip_allocation - (Optional) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.
        nic_ip_config_private_ip_address    - (Optional) The Static IP Address which should be used. Required when nic_ip_config_private_ip_allocation = "Static".
        nic_ip_config_public_ip_id          - (Optional) Reference to a Public IP Address to associate with this NIC
        nic_ip_config_primary               - (Optional) Is this the Primary IP Configuration? Must be true for the first nic_ip_config when multiple are specified. Defaults to false.

  EOT
  type = object({
    nic_name                           = string
    nic_subnet_id                      = optional(string)
    nic_dns_servers                    = optional(list(string))
    nic_edge_zone                      = optional(string)
    nic_ip_forwarding_enabled          = optional(bool)
    nic_accelerated_networking_enabled = optional(bool)
    nic_internal_dns_name_label        = optional(string)
    nic_ip_config = list(object({
      nic_ip_config_name                  = string
      nic_ip_config_private_ip_allocation = optional(string)
      nic_ip_config_private_ip_address    = optional(string)
      nic_ip_config_public_ip_id          = optional(string)
      nic_ip_config_primary               = optional(bool)
    }))
  })
  default = null
  validation {
    condition     = var.nic_default_interface == null || length([for e in var.nic_default_interface.nic_ip_config : e if coalesce(e.nic_ip_config_primary, false)]) == 1
    error_message = "You need to have ONE and ONE ONLY primary ip configuration per NIC."
  }
}

variable "nic_additional_interface" {
  description = <<EOT
    (Optional) List of additional Network Interfaces to be created.

    REQUIRED

    nic_name                            - (Required) The name of the Network Interface. Changing this forces a new resource to be created.
    
    OPTIONAL

    nic_subnet_id                       - (Optional) The ID of the Subnet where this Network Interface should be located in.
    
    nic_dns_servers                     - (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. 
                                          Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.
    
    nic_edge_zone                       - (Optional) Specifies the Edge Zone within the Azure Region where this Network Interface should exist. Changing this forces a new Network Interface to be created.
    
    nic_ip_forwarding_enabled           - (Optional) Should IP Forwarding be enabled? Defaults to false.
    
    nic_accelerated_networking_enabled  - (Optional) Should Accelerated Networking be enabled? Defaults to false. 
                                          Only certain Virtual Machine sizes are supported for Accelerated Networking.
                                          For more information check https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli.
                                          To use Accelerated Networking in an Availability Set, the Availability Set must be deployed onto an Accelerated Networking enabled cluster.
    
    nic_internal_dns_name_label         - (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.
    
    IP CONFIGURATION

    nic_ip_config -  (Required) One or more ip_configuration blocks as defined below.
        nic_ip_config_name                  - (Required) A name used for this IP Configuration.
        nic_ip_config_private_ip_allocation - (Optional) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.
        nic_ip_config_private_ip_address    - (Optional) The Static IP Address which should be used. Required when nic_ip_config_private_ip_allocation = "Static".
        nic_ip_config_public_ip_id          - (Optional) Reference to a Public IP Address to associate with this NIC
        nic_ip_config_primary               - (Optional) Is this the Primary IP Configuration? Must be true for the first nic_ip_config when multiple are specified. Defaults to false.

  EOT
  type = list(object({
    nic_name                           = string
    nic_subnet_id                      = optional(string)
    nic_dns_servers                    = optional(list(string))
    nic_edge_zone                      = optional(string)
    nic_ip_forwarding_enabled          = optional(bool)
    nic_accelerated_networking_enabled = optional(bool)
    nic_internal_dns_name_label        = optional(string)
    nic_ip_config = list(object({
      nic_ip_config_name                  = string
      nic_ip_config_private_ip_allocation = optional(string)
      nic_ip_config_private_ip_address    = optional(string)
      nic_ip_config_public_ip_id          = optional(string)
      nic_ip_config_primary               = optional(bool)
    }))
  }))
  default = null
  validation {
    condition = var.nic_additional_interface == null || try(alltrue([
      for o in var.nic_additional_interface :
      length([
        for e in o.nic_ip_config :
        e if coalesce(e.nic_ip_config_primary, false
      )]) == 1
    ]), false)
    error_message = "You need to have ONE and ONE ONLY primary ip configuration per NIC."
  }
}

#Global Variables
variable "nic_subnet_id" {
  description = "Reference to a subnet in which NICs will be created. Required when private_ip_address_version is IPv4. This is a Global Variable."
  type        = string
  default     = null
}