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

variable "number_of_win10_wks_ad" {}
variable "number_of_win11_wks_ad" {}
variable "number_of_win_srv_2016_ad" {}
variable "number_of_win_srv_2019_ad" {}
variable "number_of_win_srv_2022_ad" {}

# Active Directory Domain Services variables
variable "install_ad" {}
variable "ad_domain_name" {}
variable "ad_domain_netbios_name" {}
variable "ad_username" {
  default = "domainadmin"
}

variable "win_wks_name" {
  default = "trlab-win-wks"
}
variable "server_subnet_id" {}
variable "workstation_subnet_id" {}
variable "tags" {
  description = "The tags to apply to the resources."
  type        = map(string)  
}
variable "sa_name" {}
variable "fileshare_id" {}
variable "fileshare_name" {}
variable "sa_primary_access_key" {}

locals {
dc_prefix   = "srv-dc"
srv_prefix  = "srv-ad"
wks_prefix  = "wks-ad"
fileshare_file_name            = "win_fileshare_mount.ps1"
fileshare_path                = "\\\\${local.privatelink_fqdn}\\${var.fileshare_name}"
fileshare_script_path_upload  = "${local.fileshare_path}\\${local.fileshare_file_name}"
copy_source                  = "\\\\${local.privatelink_fqdn}\\${var.fileshare_name}\\${local.fileshare_file_name}"
copy_destination             = "C:\\terraform"
#  virtual_machine_name = join("-", [var.prefix, "dc"])
#  virtual_machine_fqdn = join(".", [local.virtual_machine_name, var.ad_domain_name])
  auto_logon_data            = "<AutoLogon><Password><Value>${var.windows_password}</Value></Password><Enabled>true</Enabled><LogonCount>3</LogonCount><Username>${var.windows_username}</Username></AutoLogon>"
  auto_logon_data_ad         = "<AutoLogon><Password><Value>${var.windows_password}</Value></Password><Enabled>true</Enabled><LogonCount>3</LogonCount><Username>${var.ad_username}</Username></AutoLogon>"
  first_logon_data            = file("${local.path_to_files}/FirstLogonCommands.xml")
  path_to_files               = "${path.module}/../compute/files"
  winrm_file                  = "${local.path_to_files}/winrm.ps1"
  privatelink_fqdn           = "${var.sa_name}.privatelink.file.core.windows.net"
  firewall_command            = "Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False"
  fileshare_mount_command     = "net use Z: ${local.fileshare_path} /user:${var.sa_name} \"${var.sa_primary_access_key}\""
  copy_fileshare_command      = "copy ${local.copy_source} ${local.copy_destination}"
  import_command       = "Import-Module ADDSDeployment"
  password_command     = "$password = ConvertTo-SecureString ${var.windows_password} -AsPlainText -Force"
  #install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
  install_ad_command   = "Install-WindowsFeature -Name AD-Domain-Services,DNS -IncludeManagementTools"
  configure_ad_command  = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode WinThreshold -DomainName ${var.ad_domain_name} -DomainNetbiosName ${var.ad_domain_netbios_name} -ForestMode WinThreshold -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
  shutdown_command     = "shutdown -r -t 10"
  exit_code_hack            = "exit 0"

  srv_ad_powershell_command = "${local.firewall_command}; ${local.import_command}; ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"
  srv_powershell_command    = "${local.firewall_command}; ${local.fileshare_mount_command}; ${local.copy_fileshare_command}; ${local.shutdown_command}; ${local.exit_code_hack};"
  wks_powershell_command    = "${local.firewall_command}; ${local.fileshare_mount_command}; ${local.copy_fileshare_command}; ${local.shutdown_command}; ${local.exit_code_hack};"
 # debian_bash_command       = "${local.debian_update_command};"
  
  srv_vm_extension_setting_install_ad  = jsonencode({commandToExecute = "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.srv_ad_powershell_command}\""})
  # srv_vm_extension_setting             = jsonencode({commandToExecute = "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.srv_powershell_command}\""})
  wks_vm_extension_setting             = jsonencode({commandToExecute = "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.wks_powershell_command}\""})
#  att_kali_vm_extension_setting         = jsonencode({commandToExecute = "sh apt update && apt upgrade -y"})     # base64encode("${path.module}/../storage/files/linux_fileshare_mount.sh")})
}
