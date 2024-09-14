# Attacker subnet
resource "azurerm_subnet" "attacker_subnet" {
  name                                             = "${var.attacker_subnet_name}-snet"
  resource_group_name                              = var.rg_name
  virtual_network_name                             = azurerm_virtual_network.lab_vnet.name
  address_prefixes                                  = var.attacker_subnet_prefix
}
# Workstation subnet
resource "azurerm_subnet" "workstation_subnet" {
  name                                             = "${var.workstation_subnet_name}-snet"
  resource_group_name                              = var.rg_name
  virtual_network_name                             = azurerm_virtual_network.lab_vnet.name
  address_prefixes                                  = var.workstation_subnet_prefix
}
# Server subnet
resource "azurerm_subnet" "server_subnet" {
  name                                             = "${var.server_subnet_name}-snet"
  resource_group_name                              = var.rg_name
  virtual_network_name                             = azurerm_virtual_network.lab_vnet.name
  address_prefixes                                  = var.server_subnet_prefix
}
# Control subnet
resource "azurerm_subnet" "control_subnet" {
  name                                             = "${var.control_subnet_name}-snet"
  resource_group_name                              = var.rg_name
  virtual_network_name                             = azurerm_virtual_network.lab_vnet.name
  address_prefixes                                  = var.control_subnet_prefix
  private_endpoint_network_policies_enabled        = false 
}
 # Bastion subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                                             = "${var.bastion_subnet_name}"
  resource_group_name                              = var.rg_name
  virtual_network_name                             = azurerm_virtual_network.lab_vnet.name
  address_prefixes                                  = var.bastion_subnet_prefix
}
