output "attacker_subnet_id" {
  value = azurerm_subnet.attacker_subnet.id
}
output "server_subnet_id" {
  value = azurerm_subnet.server_subnet.id
}
output "workstation_subnet_id" {
  value = azurerm_subnet.workstation_subnet.id
}
output "control_subnet_id" {
  value = azurerm_subnet.control_subnet.id
}
output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}
output "vnet_id" {
  value = azurerm_virtual_network.trlab_vnet.id
}
output "vnet_name" {
  value = azurerm_virtual_network.trlab_vnet.name
}
output "bastion_sga" {
  value = azurerm_subnet_network_security_group_association.tr-bastion-sga
}
