# private DNS
resource "azurerm_private_dns_zone" "sa-files" {
  depends_on             = [azurerm_subnet.control_subnet,azurerm_subnet.attacker_subnet,azurerm_subnet.workstation_subnet,azurerm_subnet.server_subnet]
  name                  = "privatelink.file.core.windows.net"
  resource_group_name   = var.rg_name
  tags                  = var.tags
}

#private DNS Link
resource "azurerm_private_dns_zone_virtual_network_link" "private-fileshare-link" {
  depends_on            = [azurerm_private_dns_zone.sa-files]
  name                  = "${var.environment}-files-dnslink"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.sa-files.name
  virtual_network_id    = azurerm_virtual_network.trlab_vnet.id
  registration_enabled  = true
  tags                  = var.tags
}
