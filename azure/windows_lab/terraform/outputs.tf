output "rg_id" {
  value = azurerm_resource_group.lab_rg.id
}
output "rg_name" {
  value = azurerm_resource_group.lab_rg.name
}
output "rg_location" {
  value = azurerm_resource_group.lab_rg.location
}
output "sa_name" {
  value = module.storage.sa_name
}
output "windows_admin_password" { # windows_local_admin_password
  value = random_password.windows_password.result
  sensitive = true
}
output "bastion_fqdn" {
  value = module.compute.bastion_fqdn
}

# Outputs for Active Directory Module
output "ad_wks_win10" {
  value = module.active_directory.ad_wks_win10
}
output "ad_wks_win11" {
  value = module.active_directory.ad_wks_win11
}
output "dc_srv_win_2019" {
  value = module.active_directory.dc_srv_win_2019
}

#####DEBUG######
/* output "debug_powershell_1" {
  value = nonsensitive(module.compute.debug_powershell_1)
}
output "debug_powershell_2" {
  value = nonsensitive(module.compute.debug_powershell_2)
}
output "debug_powershell_3" {
  value = module.compute.debug_powershell_3
}
output "debug_powershell_4" {
  value = nonsensitive(module.compute.debug_powershell_4)
}
output "kali_cloudinit_filename" {
  value = module.storage.kali_cloudinit_filename
  sensitive = true
} */
######NETWORK###############
/*
output "attacker_subnet_id" {
  value = module.network.attacker_subnet_id
}
/* output "victim_subnet_id" {
  value = module.network.victim_subnet_id
} 
output "server_subnet_id" {
  value = module.network.server_subnet_id
}
output "workstation_subnet_id" {
  value = module.network.workstation_subnet_id
}
output "control_subnet_id" {
  value = module.network.control_subnet_id
}
output "bastion_subnet_id" {
  value = module.network.bastion_subnet_id
}
*/
######COMPUTE###############
/*
# Workstations
output "wks_win10_id" {
  value = module.compute.wks_win10_id
}
output "wks_win10_ip" {
  value = module.compute.wks_win10_ip
}
output "wks_win11_id" {
  value = module.compute.wks_win11_id
}
output "wks_win11_ip" {
  value = module.compute.wks_win11_ip
}

# Server
output "server_win_srv_2016_id" {
  value = module.compute.server_win_srv_2016_id
}
output "server_win_srv_2016_ip" {
  value = module.compute.server_win_srv_2016_ip
}
output "server_win_srv_2019_id" {
  value = module.compute.server_win_srv_2019_id
}
output "server_win_srv_2019_ip" {
  value = module.compute.server_win_srv_2019_ip
}
output "server_win_srv_2022_id" {
  value = module.compute.server_win_srv_2022_id
}
output "server_win_srv_2022_ip" {
  value = module.compute.server_win_srv_2022_ip
}

# Attacker
output "attacker_kali_id" {
  value = module.compute.attacker_kali_id
}
output "attacker_kali_ip" {
  value = module.compute.attacker_kali_ip
}
output "attacker_commandovm_id" {
  value = module.compute.attacker_commandovm_id
}
output "attacker_commandovm_ip" {
  value = module.compute.attacker_commandovm_ip
} */

