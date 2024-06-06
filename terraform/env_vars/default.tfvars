######GlobalVariables#######
location                = "eastus"
environment             = "lab-default"

####EXTRAHOP#APPLIANCE#VARS#
# eda_product_key         = "EXTR-XXXX" # This value should be set to that of your EDA Product Key and then uncommented. Information on where to retrieve an EDA Product Key can be found in the Wiki linked in the README.  

######NETWORK###############
network_address_space    = ["10.0.0.0/20"]
vnet_name                = "azure-labs"

dmz_subnet_name          = "lab-dmz"
dmz_subnet_prefix         = ["10.0.6.0/24"]

attacker_subnet_name     = "lab-attacker"
attacker_subnet_prefix    = ["10.0.5.0/24"]

workstation_subnet_name  = "lab-workstation"
workstation_subnet_prefix = ["10.0.4.0/24"]

server_subnet_name       = "lab-server"
server_subnet_prefix      = ["10.0.3.0/24"]

product_subnet_name      = "lab-product"
product_subnet_prefix     = ["10.0.2.0/24"]

control_subnet_name      = "lab-control"
control_subnet_prefix     = ["10.0.1.0/24"]

bastion_subnet_name      = "AzureBastionSubnet"
bastion_subnet_prefix     = ["10.0.0.0/24"]

####ActiveDirectoryVariables######
# install_ad                                = false # This line should be uncommented, and set to `true`, if an AD deployed is required. This field is a prerequisite to the `install_exchange` being set to true.
# install_exchange                          = false # This line should be uncommented if an exchange server within the lab is required. This will add a significant amount of time to the deployment process. Do not set to `true` without `install_ad` also being set to true.
ad_domain_name                            = "corp.contoso.com"
ad_domain_netbios_name                    = "contoso"
number_of_win_srv_2016_ad                 = 0
number_of_win_srv_2019_ad                 = 0
number_of_win_srv_2022_ad                 = 0
number_of_win_srv_2022_azure_edition_ad   = 0
number_of_win10_wks_ad                    = 0
number_of_win11_wks_ad                    = 0

######COMPUTE###############
vm_size                                   = "Standard_D2s_v5"
eh_vm_size                                = "Standard_D2s_v5"
create_bastion                            = true
create_eca                                = false
create_eda                                = true
create_eta                                = false
create_exa                                = false
create_ids                                = false
windows_compute_public_ip                 = false
number_of_win_srv_2016                    = 0
number_of_win_srv_2019                    = 0
number_of_win_srv_2022                    = 0
number_of_win_srv_2022_azure_edition      = 0
number_of_win10_wks                       = 0
number_of_win11_wks                       = 0
number_of_kali_attacker                   = 1
number_of_commandovm_attacker             = 0

#####Repro Hosts##########
create_fortinet_firewall                   = false
fortinet_firewall_version                  = "7.2.0"
number_of_ubuntu_dmz                      = 0
