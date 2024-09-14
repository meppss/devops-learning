resource "azurerm_virtual_network" "lab_vnet" {
  name                    = "${var.vnet_name}-vnet" 
  location                = var.location
  resource_group_name     = var.rg_name
  address_space           = var.network_address_space
  tags                    = var.tags
}
resource "azurerm_virtual_network_dns_servers" "lab_dns_servers" {
  count                   = var.install_ad == true ? 1 : 0
  virtual_network_id      = azurerm_virtual_network.trlab_vnet.id
  dns_servers             = ["${element(var.dc_srv_2019_ip, 0)}"]
}
