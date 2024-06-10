# Define vnet resource
resource "azurerm_virtual_network" "vnet" {
  name                    = "${var.environment}-vnet" 
  location                = var.location
  resource_group_name     = azurerm_resource_group.sc_rg.name
  address_space           = var.network_address_space
  tags                    = var.tags
}

#Define vm subnet resource
resource "azurerm_subnet" "vm_subnet" {
  name                                             = "${var.environment}-vm-snet"
  resource_group_name                              = azurerm_resource_group.sc_rg.name
  virtual_network_name                             = azurerm_virtual_network.vnet.name
  address_prefixes                                 = var.subnet_prefix
}

#Define gateway subnet resource
resource "azurerm_subnet" "transport_subnet" {
  name                                             = "GatewaySubnet"
  resource_group_name                              = azurerm_resource_group.sc_rg.name
  virtual_network_name                             = azurerm_virtual_network.vnet.name
  address_prefixes                                 = var.transport_subnet_prefix
}

# Define a Public IP for the NAT gateway
resource "azurerm_public_ip" "natgw_pip" {
  name                = "${var.environment}-natgw-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.sc_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
  tags                = var.tags
}

# Define the NAT Gateway
resource "azurerm_nat_gateway" "natgw" {
  name                    = "${var.environment}-ngw"
  location                = var.location
  resource_group_name     = azurerm_resource_group.sc_rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
  tags                    = var.tags
}

# Associate the NAT GW to the Public IP
resource "azurerm_nat_gateway_public_ip_association" "natgw_pip_assoc" {
  nat_gateway_id          = azurerm_nat_gateway.natgw.id
  public_ip_address_id    = azurerm_public_ip.natgw_pip.id
}

# Associate Subnets to NAT GW
resource "azurerm_subnet_nat_gateway_association" "natgw_snet_assoc" {
  for_each = {
    # Add any additional subnets here for association to the NAT GW
    "vm-snet"      = "${azurerm_subnet.vm_subnet.id}"
  }
  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}

# NSG Association Resources
resource "azurerm_subnet_network_security_group_association" "vm-sga" {
  subnet_id                 = azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#NSG Resources
resource "azurerm_network_security_group" "nsg" {
  name = "${var.environment}-nsg"
  location = var.location
  resource_group_name = azurerm_resource_group.sc_rg.name
  tags = var.tags
}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each                      = local.nsg_rules
  name                          = each.value.name
  priority                      = each.value.priority
  direction                     = each.value.direction
  access                        = each.value.access
  protocol                      = each.value.protocol
  source_port_range             = each.value.source_port_range
  destination_port_range        = each.value.destination_port_range
  source_address_prefixes       = each.value.source_address_prefixes
  destination_address_prefix    = each.value.destination_address_prefix[0]
  resource_group_name           = azurerm_resource_group.sc_rg.name
  network_security_group_name   = azurerm_network_security_group.nsg.name 
}