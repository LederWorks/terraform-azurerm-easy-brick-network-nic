variable "nic_default_interface" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) The default Network Interfaces to be created.

    name                            - (Required) The name of the Network Interface. Changing this forces a new resource to be created.

    subnet_id                       - (Optional) The ID of the Subnet where this Network Interface should be located in.
    
    dns_servers                     - (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. 
                                      Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.
    
    edge_zone                       - (Optional) Specifies the Edge Zone within the Azure Region where this Network Interface should exist. Changing this forces a new Network Interface to be created.
    
    ip_forwarding_enabled           - (Optional) Should IP Forwarding be enabled? Defaults to false.
    
    accelerated_networking_enabled  - (Optional) Should Accelerated Networking be enabled? Defaults to false. 
                                      Only certain Virtual Machine sizes are supported for Accelerated Networking.
                                      For more information check https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli.
                                      To use Accelerated Networking in an Availability Set, the Availability Set must be deployed onto an Accelerated Networking enabled cluster.
    
    internal_dns_name_label         - (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.
    
    network_security_group_id       - (Optional) The Network Security Group ID associated with this Network Interface.
    
    application_security_group_ids  - (Optional) A list of Application Security Group IDs associated with this Network Interface.

    ip_config                       - (Required) One or more ip_configuration blocks as defined below.

        name                  - (Required) A name used for this IP Configuration.
        private_ip_allocation - (Optional) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.
        private_ip_address    - (Optional) The Static IP Address which should be used. Required when private_ip_allocation = "Static".
        public_ip_id          - (Optional) Reference to a Public IP Address to associate with this NIC
        primary               - (Optional) Is this the Primary IP Configuration? Must be true for the first ip_config when multiple are specified. Defaults to false.

  EOT
  type = object({
    name                           = string
    subnet_id                      = optional(string)
    dns_servers                    = optional(list(string))
    edge_zone                      = optional(string)
    ip_forwarding_enabled          = optional(bool)
    accelerated_networking_enabled = optional(bool)
    internal_dns_name_label        = optional(string)
    network_security_group_id      = optional(string)
    application_security_group_ids = optional(list(string))
    ip_config = optional(list(object({
      name = string
      private_ip_allocation = optional(string, "Dynamic")
      private_ip_address    = optional(string)
      public_ip_id          = optional(string)
      primary               = optional(bool, false)
      })),
      [{
        name                  = "default"
        private_ip_allocation = "Dynamic"
        primary               = true
      }]
    )
  })
  default = null
  # validation {
  #   condition = var.nic_default_interface == null || try(alltrue([
  #     length([
  #       for e in var.nic_default_interface.ip_config :
  #       e if coalesce(e.primary, false)
  #     ]) == 1
  #   ]), false)
  #   error_message = "You need to have ONE and ONE ONLY primary ip configuration per NIC."
  # }
  # validation {
  #   condition = (
  #     var.nic_default_interface == null ||
  #     (
  #       length(var.nic_default_interface.ip_config) > 0 &&
  #       length([for ip_config in var.nic_default_interface.ip_config : ip_config if ip_config.primary]) >= 1
  #     )
  #   )
  #   error_message = "You need to have at least one primary ip configuration per NIC in the default interface."
  # }

}

variable "nic_additional_interface" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) List of additional Network Interfaces to be created.

    `name`                            - (Required) The name of the Network Interface. Changing this forces a new resource to be created.

    `subnet_id`                       - (Optional) The ID of the Subnet where this Network Interface should be located in.
    
    `dns_servers`                     - (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. 
                                        Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.
    
    `edge_zone`                       - (Optional) Specifies the Edge Zone within the Azure Region where this Network Interface should exist. Changing this forces a new Network Interface to be created.
    
    `ip_forwarding_enabled`           - (Optional) Should IP Forwarding be enabled? Defaults to false.
    
    `accelerated_networking_enabled`  - (Optional) Should Accelerated Networking be enabled? Defaults to false. 
                                        Only certain Virtual Machine sizes are supported for Accelerated Networking.
                                        For more information check https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli.
                                        To use Accelerated Networking in an Availability Set, the Availability Set must be deployed onto an Accelerated Networking enabled cluster.
    
    `internal_dns_name_label`         - (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.
        
    `network_security_group_id`       - (Optional) The Network Security Group ID associated with this Network Interface.
    
    `application_security_group_ids`  - (Optional) A list of Application Security Group IDs associated with this Network Interface.
    
    `ip_config`                       - (Required) One or more ip_configuration blocks as defined below.

        `name`                  - (Required) A name used for this IP Configuration.
        `private_ip_allocation` - (Optional) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.
        `private_ip_address`    - (Optional) The Static IP Address which should be used. Required when private_ip_allocation = "Static".
        `public_ip_id`          - (Optional) Reference to a Public IP Address to associate with this NIC
        `primary`               - (Optional) Is this the Primary IP Configuration? Must be true for the first ip_config when multiple are specified. Defaults to false.

  EOT
  type = list(object({
    name                           = string
    subnet_id                      = optional(string)
    dns_servers                    = optional(list(string))
    edge_zone                      = optional(string)
    ip_forwarding_enabled          = optional(bool)
    accelerated_networking_enabled = optional(bool)
    internal_dns_name_label        = optional(string)
    network_security_group_id      = optional(string)
    application_security_group_ids = optional(list(string))
    ip_config = optional(list(object({
      name = string
      private_ip_allocation = optional(string, "Dynamic")
      private_ip_address    = optional(string)
      public_ip_id          = optional(string)
      primary               = optional(bool, false)
      })),
      [{
        name                  = "default"
        private_ip_allocation = "Dynamic"
        primary               = true
      }]
    )
  }))
  default = null
  # validation {
  #   condition = var.nic_additional_interface == null || try(alltrue([
  #     for o in var.nic_additional_interface :
  #     length([
  #       for e in o.nic_ip_config :
  #       e if coalesce(e.nic_ip_config_primary, false
  #     )]) == 1
  #   ]), false)
  #   error_message = "You need to have ONE and ONE ONLY primary ip configuration per NIC."
  # }
  # validation {
  #   condition = (
  #     var.nic_additional_interface == null ||
  #     (
  #       alltrue([
  #         for nic in var.nic_additional_interface :
  #         length(nic.ip_config) > 0 &&
  #         length([for ip_config in nic.ip_config : ip_config if ip_config.primary]) >= 1
  #       ])
  #     )
  #   )
  #   error_message = "You need to have at least one primary ip configuration per NIC."
  # }
}

#Global Variables
variable "nic_subnet_id" {
  description = "Reference to a subnet in which NICs will be created. Required when private_ip_address_version is IPv4. This is a Global Variable."
  type        = string
  default     = null
}

variable "nic_dns_servers" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. 
    Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.
  EOT
  type        = list(string)
  default     = null
}