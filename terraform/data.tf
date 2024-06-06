data "azurerm_subnet" "tinfoilvpn" { #--We need to look this up as as list as we need to get the ID of the Subnet
    name                 = var.transport_subnet_address_space[count.index]
    count                = length(var.transport_subnet_address_space)
    resource_group_name  = azurerm_resource_group.sc_rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
}