output "azure_bgp_ip" {
  value = azurerm_virtual_network_gateway.prisma_sc_vpng.ip_configuration[0]
}

output "azure_bgp_asn" {
  value = azurerm_virtual_network_gateway.prisma_sc_vpng.bgp_settings[0]
}

/* output "azure_tunnel_ip" {
  value = azurerm_virtual_network_gateway.prisma_sc_vpng.ip_configuration.private_ip_address
} */

output "azure_vm_ip" {
  value = azurerm_linux_virtual_machine.ubuntu.*.private_ip_address
}

output "shared_key" {
  value = random_password.psk_gen.result
}