output "ad_wks_win10" {
  value = [azurerm_windows_virtual_machine.ad_wks_win10.*.name, azurerm_network_interface.ad_wks_win10_nic.*.private_ip_address]
}
output "ad_wks_win11" {
  value = [azurerm_windows_virtual_machine.ad_wks_win11.*.name, azurerm_network_interface.ad_wks_win11_nic.*.private_ip_address]
}
output "dc_srv_win_2019" {
  value = [azurerm_windows_virtual_machine.dc_srv_win_2019.*.name, azurerm_network_interface.dc_srv_win_2019_nic.*.private_ip_address]
}
output "dc_srv_2019_ip" {
  value = azurerm_network_interface.dc_srv_win_2019_nic.*.private_ip_address
}
