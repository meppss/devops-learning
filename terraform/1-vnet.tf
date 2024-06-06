# Define vnet resource
resource "azurerm_virtual_network" "vnet" {
  name                    = "${var.environment}-vnet" 
  location                = var.location
  resource_group_name     = azurerm_resource_group.sc_rg.name
  address_space           = var.network_address_space
  tags                    = var.tags
}

#Define gateway subnet resource
resource "azurerm_subnet" "vm_subnet" {
  name                                             = "${var.environment}-vm-snet"
  resource_group_name                              = azurerm_resource_group.sc_rg.name
  virtual_network_name                             = azurerm_virtual_network.vnet.name
  address_prefixes                                 = var.subnet_prefix
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
  name = "${var.environment}-sg"
  location = var.location
  resource_group_name = azurerm_resource_group.sc_rg.name
  tags = var.tags
  
  dynamic security_rule {
    for_each = var.sg_rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefixes     = security_rule.value["source_address_prefixes"]
      destination_address_prefix  = security_rule.value["destination_address_prefix"]
    }
  }
}

