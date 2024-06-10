output "virtual_network_gateway_ip" {
  value = azurerm_virtual_network_gateway.prisma_sc_vpng.ip_configuration
}