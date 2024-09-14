resource "azurerm_network_interface" "ad_wks_win10_nic" {
  count               = var.install_ad == true ? var.number_of_win10_wks_ad : 0
  depends_on          = [var.workstation_subnet_id] 
#  depends_on          = [azurerm_public_ip.ad_wks_win10_pip, var.workstation_subnet_id]
  name                = "${local.wks_prefix}win10-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "${local.wks_prefix}-win10-ipconfig-${count.index}"
    subnet_id                     = var.workstation_subnet_id
    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = "${element(azurerm_public_ip.ad_wks_win10_pip.*.id, count.index)}"   # azurerm_public_ip.ad_wks_win10_pip[count.index].id
  #  private_ip_address            = var.wks_ip
  }
}

resource "azurerm_windows_virtual_machine" "ad_wks_win10" {
  count                           = var.install_ad == true ? var.number_of_win10_wks_ad : 0
  depends_on                      = [azurerm_network_interface.ad_wks_win10_nic, azurerm_windows_virtual_machine.dc_srv_win_2019]
  name                            = "${local.wks_prefix}-win10-${count.index}" # "wks-${var.env_name}-${count.index}" "wks-win-wks-vm"
  location                        = var.location
  resource_group_name             = var.rg_name
  size                            = var.vm_size # "Standard_D4s_v4"
  provision_vm_agent              = true
  computer_name                   = "${local.wks_prefix}-win10-${count.index}"
  admin_username                  = var.windows_username
  admin_password                  = var.windows_password
  network_interface_ids           = ["${element(azurerm_network_interface.ad_wks_win10_nic.*.id, count.index)}"]
  custom_data                     = base64encode(file("${local.winrm_file}"))

  os_disk {
    caching                       = "ReadWrite"
    name                          = "${local.wks_prefix}-win10-osdisk-${count.index}"
    disk_size_gb                  = "250"
    storage_account_type          = "StandardSSD_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-ent"
    version   = "latest"
  }
  additional_unattend_content {
    setting = "AutoLogon"
    content = local.auto_logon_data
  }
  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = local.first_logon_data
  #  content = base64encode(file("${path.module}/files/TestLogonCommands.xml"))
  }
  winrm_listener {
    protocol = "Http"
    # certificate_url = "https://"
  }
  tags = merge(var.tags,
    {
    "ad-role" = "domain-workstation"
    "kind"="workstation"
    "os"="windows"
    })
  }

resource "azurerm_virtual_machine_extension" "ad_wks_win10_vm_extension_network_watcher" {
  count                      = var.install_ad == true ? var.number_of_win10_wks_ad : 0
  depends_on                 = [azurerm_windows_virtual_machine.ad_wks_win10]
  name                       = "win10netwatch${count.index}"
  virtual_machine_id         = "${element(azurerm_windows_virtual_machine.ad_wks_win10.*.id, count.index )}"
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "ad_wks_win10_vm_extension_bootstrap" {
  count                      = var.install_ad == true ? var.number_of_win10_wks_ad : 0
  depends_on                 = [azurerm_windows_virtual_machine.ad_wks_win10]
  name                       = "win10adpostdeploy${count.index}"
  virtual_machine_id         = "${element(azurerm_windows_virtual_machine.ad_wks_win10.*.id, count.index )}"
  publisher                  = "Microsoft.Compute" # "Microsoft.Azure.Extensions"
  type                       = "CustomScriptExtension" # "CustomScript"
  type_handler_version       = "1.9"
  settings = local.wks_vm_extension_setting
}

resource "azurerm_virtual_machine_extension" "ad_wks_win10_join_domain" {
  count                = var.install_ad == true ? var.number_of_win10_wks_ad : 0
  depends_on           = [time_sleep.wait-for-dc, azurerm_virtual_machine_extension.ad_wks_win10_vm_extension_bootstrap]
  name                 = "win10ad-domainjoin${count.index}"
  virtual_machine_id   = "${element(azurerm_windows_virtual_machine.ad_wks_win10.*.id, count.index )}"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  # NOTE: the `OUPath` field is intentionally blank, to put it in the Computers OU
  settings = <<SETTINGS
    {
        "Name": "${var.ad_domain_name}",
        "OUPath": "",
        "User": "${var.ad_domain_name}\\${var.ad_username}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS
  protected_settings = <<SETTINGS
    {
        "Password": "${var.windows_password}"
    }
SETTINGS
}
