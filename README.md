<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable-file MD033 MD012 -->
# terraform-azurerm-easy-brick-network-nic
LederWorks Easy Network Interface Card Brick Module

This module were created by [LederWorks](https://lederworks.com) IaC enthusiasts.

## About This Module
This module implements the [NIC](https://lederworks.com/docs/microsoft-azure/bricks/network/#network-interface-card) reference Insight.

## How to Use This Modul
- Ensure Azure credentials are [in place](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure) (e.g. `az login` and `az account set --subscription="SUBSCRIPTION_ID"` on your workstation)
- Owner role or equivalent is required!
- Ensure pre-requisite resources are created.
- Create a Terraform configuration that pulls in this module and specifies values for the required variables.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=1.3.4)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.67.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.67.0)

## Example

```hcl
################################ Resource Group
resource "azurerm_resource_group" "network-nic" {
  name     = "network-nic"
  location = "East US 2"
  tags     = local.tags
}

################################ Public IPs
resource "azurerm_public_ip" "public-ip1" {
  name                = "public-ip1"
  resource_group_name = azurerm_resource_group.network-nic.name
  location            = azurerm_resource_group.network-nic.location
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "public-ip2" {
  name                = "public-ip2"
  resource_group_name = azurerm_resource_group.network-nic.name
  location            = azurerm_resource_group.network-nic.location
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "public-ip3" {
  name                = "public-ip3"
  resource_group_name = azurerm_resource_group.network-nic.name
  location            = azurerm_resource_group.network-nic.location
  allocation_method   = "Static"
}

################################ NIC Module
module "network-nic" {
  source  = "LederWorks/easy-brick-network-nic/azurerm"
  version = "X.X.X"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.network-nic

  #Tags
  tags = local.tags

  #Global Variables
  nic_subnet_id = ""

  nic_dns_servers = ["4.4.4.4", "8.8.8.8"]

  #Variables

  ###########################
  #### Default Interface ####
  ###########################

  nic_default_interface = {
    name                           = "vnic-001"
    subnet_id                      = ""
    dns_servers                    = ["4.4.4.4", "8.8.8.8"]
    edge_zone                      = ""
    ip_forwarding_enabled          = true
    accelerated_networking_enabled = true
    internal_dns_name_label        = ""

    ip_config = [
      #default-primary
      {
        name                  = "default-primary"
        private_ip_allocation = "Static"
        private_ip_address    = "192.168.169.170"
        primary               = true
      },
      #default-public
      {
        name         = "default-public"
        public_ip_id = azurerm_public_ip.public-ip1.id
      }
    ]
  }

  ###############################
  #### Additional Interfaces ####
  ###############################

  nic_additional_interface = [

    #vnic-002
    {
      name                           = "vnic-002"
      subnet_id                      = ""
      dns_servers                    = ["4.4.4.4", "8.8.8.8"]
      edge_zone                      = ""
      ip_forwarding_enabled          = true
      accelerated_networking_enabled = true
      internal_dns_name_label        = ""
      ip_config = [
        #primary
        {
          name    = "primary"
          private_ip_allocation = "Static"
          private_ip_address    = "192.168.169.171"
          primary = true
        },
        #public
        {
          name         = "public"
          public_ip_id = azurerm_public_ip.public-ip2.id
        }
      ]
    },
    #vnic-003
    {
      name = "vnic-003"
      ip_config = [
        #primary
        {
          name    = "primary"
          primary = true
        },
        #public
        {
          name         = "public"
          public_ip_id = azurerm_public_ip.public-ip3.id
        }
      ]
    }
  ]
  
}

################################ Outputs
output "nic_interface_list" {
  value = module.network-nic.nic_interface_list
}
output "nic_nsg_association" {
  value = module.network-nic.nic_nsg_association
}
output "nic_asg_association" {
  value = module.network-nic.nic_asg_association
}
```

## Resources

The following resources are used by this module:

- [azurerm_network_interface.additional_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) (resource)
- [azurerm_network_interface.default_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) (resource)
- [azurerm_network_interface_application_security_group_association.asg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) (resource)
- [azurerm_network_interface_security_group_association.nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_resource_group_object"></a> [resource\_group\_object](#input\_resource\_group\_object)

Description: (Required) Resource Group Object

Type: `any`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: (Required) ID of the Subscription

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_nic_additional_interface"></a> [nic\_additional\_interface](#input\_nic\_additional\_interface)

Description:     <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) List of additional Network Interfaces to be created.

    name                            - (Required) The name of the Network Interface. Changing this forces a new resource to be created.

    subnet\_id                       - (Optional) The ID of the Subnet where this Network Interface should be located in.  

    dns\_servers                     - (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface.   
                                      Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.  

    edge\_zone                       - (Optional) Specifies the Edge Zone within the Azure Region where this Network Interface should exist. Changing this forces a new Network Interface to be created.  

    ip\_forwarding\_enabled           - (Optional) Should IP Forwarding be enabled? Defaults to false.  

    accelerated\_networking\_enabled  - (Optional) Should Accelerated Networking be enabled? Defaults to false.   
                                      Only certain Virtual Machine sizes are supported for Accelerated Networking.  
                                      For more information check https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli.  
                                      To use Accelerated Networking in an Availability Set, the Availability Set must be deployed onto an Accelerated Networking enabled cluster.  

    internal\_dns\_name\_label         - (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.  
      
    network\_security\_group\_id       - (Optional) The Network Security Group ID associated with this Network Interface.  

    application\_security\_group\_ids  - (Optional) A list of Application Security Group IDs associated with this Network Interface.  

    ip\_config                       - (Required) One or more ip\_configuration blocks as defined below.

        name                  - (Required) A name used for this IP Configuration.  
        private\_ip\_allocation - (Optional) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.  
        private\_ip\_address    - (Optional) The Static IP Address which should be used. Required when private\_ip\_allocation = "Static".  
        public\_ip\_id          - (Optional) Reference to a Public IP Address to associate with this NIC  
        primary               - (Optional) Is this the Primary IP Configuration? Must be true for the first ip\_config when multiple are specified. Defaults to false.

Type:

```hcl
list(object({
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
      # name                  = optional(string, "default")
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
```

Default: `null`

### <a name="input_nic_default_interface"></a> [nic\_default\_interface](#input\_nic\_default\_interface)

Description:     <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) The default Network Interfaces to be created.

    name                            - (Required) The name of the Network Interface. Changing this forces a new resource to be created.

    subnet\_id                       - (Optional) The ID of the Subnet where this Network Interface should be located in.  

    dns\_servers                     - (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface.   
                                      Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.  

    edge\_zone                       - (Optional) Specifies the Edge Zone within the Azure Region where this Network Interface should exist. Changing this forces a new Network Interface to be created.  

    ip\_forwarding\_enabled           - (Optional) Should IP Forwarding be enabled? Defaults to false.  

    accelerated\_networking\_enabled  - (Optional) Should Accelerated Networking be enabled? Defaults to false.   
                                      Only certain Virtual Machine sizes are supported for Accelerated Networking.  
                                      For more information check https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli.  
                                      To use Accelerated Networking in an Availability Set, the Availability Set must be deployed onto an Accelerated Networking enabled cluster.  

    internal\_dns\_name\_label         - (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.  

    network\_security\_group\_id       - (Optional) The Network Security Group ID associated with this Network Interface.  

    application\_security\_group\_ids  - (Optional) A list of Application Security Group IDs associated with this Network Interface.

    ip\_config                       - (Required) One or more ip\_configuration blocks as defined below.

        name                  - (Required) A name used for this IP Configuration.  
        private\_ip\_allocation - (Optional) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.  
        private\_ip\_address    - (Optional) The Static IP Address which should be used. Required when private\_ip\_allocation = "Static".  
        public\_ip\_id          - (Optional) Reference to a Public IP Address to associate with this NIC  
        primary               - (Optional) Is this the Primary IP Configuration? Must be true for the first ip\_config when multiple are specified. Defaults to false.

Type:

```hcl
object({
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
      # name                  = optional(string, "default")
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
```

Default: `null`

### <a name="input_nic_dns_servers"></a> [nic\_dns\_servers](#input\_nic\_dns\_servers)

Description:     <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface.   
    Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.

Type: `list(string)`

Default: `null`

### <a name="input_nic_subnet_id"></a> [nic\_subnet\_id](#input\_nic\_subnet\_id)

Description: Reference to a subnet in which NICs will be created. Required when private\_ip\_address\_version is IPv4. This is a Global Variable.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: BYO Tags, as a map(string)

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_nic_additional_asg_association"></a> [nic\_additional\_asg\_association](#output\_nic\_additional\_asg\_association)

Description: FOR TROUBLESHOOTING

### <a name="output_nic_additional_interface"></a> [nic\_additional\_interface](#output\_nic\_additional\_interface)

Description: FOR TROUBLESHOOTING

### <a name="output_nic_additional_nsg_association"></a> [nic\_additional\_nsg\_association](#output\_nic\_additional\_nsg\_association)

Description: FOR TROUBLESHOOTING

### <a name="output_nic_asg_association"></a> [nic\_asg\_association](#output\_nic\_asg\_association)

Description: A list of all asg associations.

### <a name="output_nic_default_asg_association"></a> [nic\_default\_asg\_association](#output\_nic\_default\_asg\_association)

Description: FOR TROUBLESHOOTING

### <a name="output_nic_default_interface"></a> [nic\_default\_interface](#output\_nic\_default\_interface)

Description: FOR TROUBLESHOOTING

### <a name="output_nic_default_nsg_association"></a> [nic\_default\_nsg\_association](#output\_nic\_default\_nsg\_association)

Description: FOR TROUBLESHOOTING

### <a name="output_nic_interface_list"></a> [nic\_interface\_list](#output\_nic\_interface\_list)

Description: A list of all interfaces.

### <a name="output_nic_nsg_association"></a> [nic\_nsg\_association](#output\_nic\_nsg\_association)

Description: A list of all nsg associations.

<!-- markdownlint-disable-file MD033 MD012 -->
## Contributing

* If you think you've found a bug in the code or you have a question regarding
  the usage of this module, please reach out to us by opening an issue in
  this GitHub repository.
* Contributions to this project are welcome: if you want to add a feature or a
  fix a bug, please do so by opening a Pull Request in this GitHub repository.
  In case of feature contribution, we kindly ask you to open an issue to
  discuss it beforehand.

## License

```text
MIT License

Copyright (c) 2023 LederWorks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
<!-- END_TF_DOCS -->