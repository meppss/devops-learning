# output values for Windows 10 instances
output "wks_win10_id" {
  value = azurerm_windows_virtual_machine.wks_win10.*.id
}
output "wks_win10_name" {
  value = azurerm_windows_virtual_machine.wks_win10.*.name
}
output "wks_win10_ip" {
  value = azurerm_windows_virtual_machine.wks_win10.*.public_ip_address
}

# output values for Windows 11 instances
output "wks_win11_id" {
  value = azurerm_windows_virtual_machine.wks_win11.*.id
}
output "wks_win11_name" {
  value = azurerm_windows_virtual_machine.wks_win11.*.name
}
output "wks_win11_ip" {
  value = azurerm_windows_virtual_machine.wks_win11.*.public_ip_address
}

# output values for Windows server 2016 instances
output "server_win_srv_2016_id" {
  value = azurerm_windows_virtual_machine.srv_win_2016.*.id
}
output "server_win_srv_2016_name" {
  value = azurerm_windows_virtual_machine.srv_win_2016.*.name
}
output "server_win_srv_2016_ip" {
  value = azurerm_windows_virtual_machine.srv_win_2016.*.public_ip_address
}

# output values for Windows server 2019 instances
output "server_win_srv_2019_id" {
  value = azurerm_windows_virtual_machine.srv_win_2019.*.id
}
output "server_win_srv_2019_name" {
  value = azurerm_windows_virtual_machine.srv_win_2019.*.name
}
output "server_win_srv_2019_ip" {
  value = azurerm_windows_virtual_machine.srv_win_2019.*.public_ip_address
}

# output values for Windows server 2022 instances
output "server_win_srv_2022_id" {
  value = azurerm_windows_virtual_machine.srv_win_2022.*.id
}
output "server_win_srv_2022_name" {
  value = azurerm_windows_virtual_machine.srv_win_2022.*.name
}
output "server_win_srv_2022_ip" {
  value = azurerm_windows_virtual_machine.srv_win_2022.*.public_ip_address
}

# outputs for Kali
output "attacker_kali_id" {
  value = azurerm_linux_virtual_machine.attacker_kali.*.id
}
output "attacker_kali_name" {
  value = azurerm_linux_virtual_machine.attacker_kali.*.name
}
output "attacker_kali_ip" {
  value = azurerm_linux_virtual_machine.attacker_kali.*.public_ip_address
}

# outputs for Bastion host
output "bastion_fqdn" {
  value = azurerm_bastion_host.azbastion_host.*.dns_name
}

# DEBUG OUTPUTS
output "debug_powershell_1" {
  value = local.srv_vm_extension_setting
}
output "debug_powershell_2" {
  value = local.srv_powershell_command
}
output "debug_powershell_3" {
  value = local.copy_fileshare_command
}
output "debug_powershell_4" {
  value = local.fileshare_mount_command
}
output "debug_bash_1" {
  value = local.fileshare_local_bash_path
}
output "debug_sa_user" {
  value = var.sa_name
}
output "debug_sa_key" {
  value = var.sa_primary_access_key
}
