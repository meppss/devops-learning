resource "azurerm_private_endpoint" "trlab_sa_private_endpoint_control_snet" {
  # for_each            = {for subnet in var.subnet_ids : subnet.name => subnet}
  depends_on             = [ var.sa_id,azurerm_subnet.control_subnet,azurerm_private_dns_zone.sa-files,azurerm_private_dns_zone_virtual_network_link.private-fileshare-link ]
  name                   = "pep-ctrl${var.sta_random_id_hex}" #"${var.sa_name}-pep"
  location               = var.location
  resource_group_name    = var.rg_name
  subnet_id              = azurerm_subnet.control_subnet.id # var.control_subnet_id # var.subnet_ids[each.key]
  private_dns_zone_group {
    name                 = "${var.environment}-private-dns-zone-group"
    private_dns_zone_ids = [ azurerm_private_dns_zone.sa-files.id ]
  }
  private_service_connection {
    name                           = "pl-ctrl${var.sta_random_id_hex}" #"${var.sa_name}-pl"
    private_connection_resource_id = var.sa_id # azurerm_storage_account.trlab_sa.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
}
