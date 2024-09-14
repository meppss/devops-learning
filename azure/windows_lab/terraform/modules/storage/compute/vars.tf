variable "rg_name" {}
variable "location" {}
variable "environment" {}
variable "vnet_name" {
  default = "lab-vnet"
}
variable "vm_size" {}
variable "windows_password" {}
variable "windows_username" {
  type = string
  default = "azureuser"
}
variable "create_bastion" {}
variable "number_of_win10_wks" {}
variable "number_of_win11_wks" {}
variable "number_of_win_srv_2016" {}
variable "number_of_win_srv_2019" {}
variable "number_of_win_srv_2022" {}
variable "number_of_kali_attacker" {}
variable "number_of_commandovm_attacker" {}

variable "win_wks_name" {
  default = "lab-win-wks"
}
variable "attacker_subnet_id" {}
variable "server_subnet_id" {}
variable "workstation_subnet_id" {}
variable "control_subnet_id" {}
variable "bastion_subnet_id" {}
variable "bastion_sga" {}
variable "tags" {
  description = "The tags to apply to the resources."
  type        = map(string)  
}
variable "sa_name" {}
variable "fileshare_id" {}
variable "fileshare_name" {}
variable "sa_primary_access_key" {}
variable "kali_cloudinit_filename" {}

locals {
fileshare_file_name            = "win_fileshare_mount.ps1"
fileshare_path                = "\\\\${local.privatelink_fqdn}\\${var.fileshare_name}"
fileshare_script_path_upload  = "${local.fileshare_path}\\${local.fileshare_file_name}"
copy_source                  = "\\\\${local.privatelink_fqdn}\\${var.fileshare_name}\\${local.fileshare_file_name}"
copy_destination             = "C:\\terraform"
#  virtual_machine_name = join("-", [var.prefix, "dc"])
#  virtual_machine_fqdn = join(".", [local.virtual_machine_name, var.ad_domain_name])
  auto_logon_data            = "<AutoLogon><Password><Value>${var.windows_password}</Value></Password><Enabled>true</Enabled><LogonCount>3</LogonCount><Username>${var.windows_username}</Username></AutoLogon>"
  first_logon_data            = file("${path.module}/files/FirstLogonCommands.xml")
#  vm_password = "Azureuser123!"
#  custom_data_params   = "Param($RemoteHostName = \"${local.virtual_machine_fqdn}\", $ComputerName = \"${local.virtual_machine_name}\")"
#  custom_data          = base64encode(join(" ", [local.custom_data_params, file("${path.module}/files/winrm.ps1")]))
  privatelink_fqdn           = "${var.sa_name}.privatelink.file.core.windows.net"
  firewall_command            = "Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False"
  fileshare_mount_command     = "net use Z: ${local.fileshare_path} /user:${var.sa_name} \"${var.sa_primary_access_key}\""
#  copy_fileshare_command      = "copy S:\\${local.fileshare_file_name} C:\\terraform"
#  copy_fileshare_command = "copy S:\\${local.fileshare_file_name} C:\\terraform"
  copy_fileshare_command      = "copy ${local.copy_source} ${local.copy_destination}"
#  fileshare_creds        = "$fs_creds = Get-Credential"
#  fileshare_command      = "${local.fs_creds}; New-SmbGlobalMapping -RemotePath \\\\${local.privatelink_fqdn}\\${var.fileshare_name} -Credential $fs_creds -LocalPath S: -Persistent $true -RequirePrivacy $true"
#  fileshare_command      = "New-SmbMapping -LocalPath 'S:' -RemotePath '\\\\${local.privatelink_fqdn}\\${var.fileshare_name}' -UserName ${var.sa_name} -Password ${var.sa_primary_access_key} -GlobalMapping -Persistent $true -RequirePrivacy $true -SaveCredentials"
#  fileshare_command      = "New-PSDrive -PSProvider FileSystem -Name S -Root '\\\\${local.privatelink_fqdn}\\${var.fileshare_name}' -UserName ${var.sa_name} -Password ${var.sa_primary_a 
  import_command       = "Import-Module ADDSDeployment"
  password_command     = "$password = ConvertTo-SecureString ${var.windows_password} -AsPlainText -Force"
  #install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
  install_ad_command   = "Install-WindowsFeature -Name AD-Domain-Services,DNS -IncludeManagementTools"
#  configure_ad_command  = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode WinThreshold -DomainName ${var.ad_domain_name} -DomainNetbiosName ${var.ad_domain_netbios_name} -ForestMode WinThreshold -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
  shutdown_command     = "shutdown -r -t 10"
#  shutdown_command          = "shutdown /r"
  exit_code_hack            = "exit 0"

#  debian_update_command     = "echo 'hello'" #"apt update && apt upgrade -y"
#  srv_ad_powershell_command = "${local.firewall_command}; ${local.import_command}; ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"
  srv_powershell_command    = "${local.firewall_command}; ${local.fileshare_mount_command}; ${local.copy_fileshare_command}; ${local.shutdown_command}; ${local.exit_code_hack};"
  wks_powershell_command    = "${local.firewall_command}; ${local.fileshare_mount_command}; ${local.copy_fileshare_command}; ${local.shutdown_command}; ${local.exit_code_hack};"
 # debian_bash_command       = "${local.debian_update_command};"
  
#  srv_vm_extension_setting_install_ad  = jsonencode({commandToExecute = "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.srv_ad_powershell_command}\""})
  srv_vm_extension_setting             = jsonencode({commandToExecute = "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.srv_powershell_command}\""})
  wks_vm_extension_setting             = jsonencode({commandToExecute = "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.wks_powershell_command}\""})
#  att_kali_vm_extension_setting         = jsonencode({commandToExecute = "sh apt update && apt upgrade -y"})     # base64encode("${path.module}/../storage/files/linux_fileshare_mount.sh")})
}
