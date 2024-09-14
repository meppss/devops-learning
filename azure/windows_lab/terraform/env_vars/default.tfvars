location                = "eastus"
#lab_id  = "123456-trlab"
environment             = "lab-default"
#key = "trlab1234.terraform.tfstate"
/* tags = {
  "lab"         = "placeholder-testing"
  "Team"        = "default-team"
  "Environment" = "default-environment"
  "User"        = "default-user"
} */
######NETWORK###############
network_address_space    = "10.0.0.0/20"
vnet_name                = "lab"

attacker_subnet_name     = "lab-attacker"
attacker_subnet_prefix    = ["10.0.5.0/24"]

workstation_subnet_name  = "lab-workstation"
workstation_subnet_prefix = ["10.0.4.0/24"]

server_subnet_name       = "lab-server"
server_subnet_prefix      = ["10.0.3.0/24"]

control_subnet_name      = "lab-control"
control_subnet_prefix     = ["10.0.1.0/24"]

bastion_subnet_name      = "AzureBastionSubnet"
bastion_subnet_prefix     = ["10.0.0.0/24"]

####ActiveDirectoryVariables######
install_ad                    = true
ad_domain_name                = "consoto.com" 
ad_domain_netbios_name        = "consoto"
number_of_win_srv_2016_ad     = 0
number_of_win_srv_2019_ad     = 0
number_of_win_srv_2022_ad     = 0
number_of_win10_wks_ad        = 1
number_of_win11_wks_ad        = 1

######COMPUTE###############
vm_size                       = "Standard_D4s_v4"
create_bastion                = true
create_eda                    = true
number_of_win_srv_2016        = 0
number_of_win_srv_2019        = 0
number_of_win_srv_2022        = 0
number_of_win10_wks           = 0
number_of_win11_wks           = 0
number_of_kali_attacker       = 1
number_of_commandovm_attacker = 0
