# Define a Public IP for the NAT gateway
resource "azurerm_public_ip" "natgw_pip" {
  name                = "${var.environment}-natgw-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
  tags                = var.tags
}
#Define the prefix length of the public IP for the NAT Gateway
resource "azurerm_public_ip_prefix" "natgw_ippre" {
  depends_on = [azurerm_public_ip.natgw_pip]
  name                = "${var.environment}-natgw-ippre"
  location            = var.location
  resource_group_name = var.rg_name
  prefix_length        = 30
  zones               = ["1"]
}
# Define the NAT Gateway
resource "azurerm_nat_gateway" "lab_natgw" {
  name                    = "${var.environment}-ngw"
  location                = var.location
  resource_group_name     = var.rg_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
  tags                    = var.tags
}
# Associate the NAT GW to the Public IP
resource "azurerm_nat_gateway_public_ip_prefix_association" "lab_nat_gw_pip_assoc" {
  depends_on = [azurerm_nat_gateway.lab_natgw]
  nat_gateway_id      = azurerm_nat_gateway.lab_natgw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.natgw_ippre.id
}

# Associate Subnets to NAT GW
resource "azurerm_subnet_nat_gateway_association" "lab_nat_gw_snet_assoc" {
  depends_on = [azurerm_nat_gateway.lab_natgw, azurerm_subnet.attacker_subnet,azurerm_subnet.workstation_subnet, azurerm_subnet.server_subnet, azurerm_subnet.control_subnet]
  for_each = {
    "att-snet"      = "${azurerm_subnet.attacker_subnet.id}"
    "wks-snet"      = "${azurerm_subnet.workstation_subnet.id}"
    "srv-snet"      = "${azurerm_subnet.server_subnet.id}"
    "control-snet"  = "${azurerm_subnet.control_subnet.id}"
  }
  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.lab_natgw.id
}
