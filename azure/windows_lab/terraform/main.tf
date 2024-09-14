# Resource group for Lab environment
resource "azurerm_resource_group" "lab_rg" {
  name     = "${var.lab_id}-rg"
  location = var.location
  tags = var.tags
}

resource "random_pet" "storage_name" {
  length = 1 
}

resource "random_integer" "storage_name_number" {
  min = 1
  max = 99
}

resource "random_password" "windows_password" {
  length  = 16
  special = false
  numeric = true
  upper   = true
  lower   = true
}

resource "random_id" "sta_random_id" {
  byte_length = 8
}

# vnet module inputs
module "network" {
  source                     = "./modules/network"
  tags                       = var.tags
  rg_name                    = azurerm_resource_group.lab_rg.name
  location                   = var.location
  environment                = var.environment
  vnet_name                  = var.vnet_name
  network_address_space      = ["10.0.0.0/20"]
  attacker_subnet_name       = var.attacker_subnet_name
  attacker_subnet_prefix     = var.attacker_subnet_prefix  #["10.0.5.0/24"]
  workstation_subnet_name    = var.workstation_subnet_name
  workstation_subnet_prefix  = var.workstation_subnet_prefix    #["10.0.4.0/24"]
  server_subnet_name         = var.server_subnet_name
  server_subnet_prefix       = var.server_subnet_prefix      #["10.0.3.0/24"]
  control_subnet_name        = var.control_subnet_name
  control_subnet_prefix      = var.control_subnet_prefix  #["10.0.1.0/24"]
  bastion_subnet_name        = var.bastion_subnet_name
  bastion_subnet_prefix      = var.bastion_subnet_prefix   #["10.0.0.0/24"]
  sa_id                      = module.storage.sa_id
  fileshare_id               = module.storage.fileshare_id
  sta_random_id_hex          = lower(random_id.sta_random_id.hex)
  dc_srv_2019_ip             = module.active_directory.dc_srv_2019_ip
  install_ad                 = var.install_ad
}

# instance module inputs
module "active_directory" {
  depends_on                    = [module.storage] 
  source                        = "./modules/active_directory"
  tags                          = var.tags
  rg_name                       = azurerm_resource_group.lab_rg.name
  location                      = var.location
  environment                   = var.environment
  vm_size                       = var.vm_size
  windows_password              = random_password.windows_password.result
  install_ad                    = var.install_ad
  ad_domain_name                = var.ad_domain_name
  ad_domain_netbios_name        = var.ad_domain_netbios_name
  number_of_win10_wks_ad        = var.number_of_win10_wks_ad
  number_of_win11_wks_ad        = var.number_of_win11_wks_ad
  number_of_win_srv_2016_ad     = var.number_of_win_srv_2016_ad
  number_of_win_srv_2019_ad     = var.number_of_win_srv_2019_ad
  number_of_win_srv_2022_ad     = var.number_of_win_srv_2022_ad
  server_subnet_id              = module.network.server_subnet_id
  workstation_subnet_id         = module.network.workstation_subnet_id
  sa_name                       = module.storage.sa_name 
  fileshare_name                = module.storage.fileshare_name
  fileshare_id                  = module.storage.fileshare_id
  sa_primary_access_key         = module.storage.sa_primary_access_key
}

# instance module inputs
module "compute" {
  depends_on                    = [module.storage] 
  source                        = "./modules/compute"
  tags                          = var.tags
  rg_name                       = azurerm_resource_group.lab_rg.name
  location                      = var.location
  environment                   = var.environment
  vm_size                       = var.vm_size
  windows_password              = random_password.windows_password.result
  create_bastion                = var.create_bastion
  create_eda                    = var.create_eda
  number_of_win10_wks           = var.number_of_win10_wks
  number_of_win11_wks           = var.number_of_win11_wks
  number_of_win_srv_2016        = var.number_of_win_srv_2016
  number_of_win_srv_2019        = var.number_of_win_srv_2019
  number_of_win_srv_2022        = var.number_of_win_srv_2022
  number_of_kali_attacker       = var.number_of_kali_attacker 
  attacker_subnet_id            = module.network.attacker_subnet_id
  server_subnet_id              = module.network.server_subnet_id
  workstation_subnet_id         = module.network.workstation_subnet_id
  control_subnet_id             = module.network.control_subnet_id
  bastion_subnet_id             = module.network.bastion_subnet_id
  bastion_sga                   = module.network.bastion_sga
  sa_name                       = module.storage.sa_name 
  fileshare_name                = module.storage.fileshare_name
  fileshare_id                  = module.storage.fileshare_id
  sa_primary_access_key         = module.storage.sa_primary_access_key
  kali_cloudinit_filename       = module.storage.kali_cloudinit_filename
}

# module - storage inputs
module "storage" {
  source                        = "./modules/storage"
  tags                          = var.tags
  rg_name                       = azurerm_resource_group.lab_rg.name
  location                      = var.location
  environment                   = var.environment
  attacker_subnet_id            = module.network.attacker_subnet_id
  server_subnet_id              = module.network.server_subnet_id
  workstation_subnet_id         = module.network.workstation_subnet_id
  control_subnet_id             = module.network.control_subnet_id
  sta_random_id_hex             = lower(random_id.sta_random_id.hex)
  admin_password                = random_password.windows_password.result
}
