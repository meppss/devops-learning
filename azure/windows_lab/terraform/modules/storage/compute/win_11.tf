resource "azurerm_public_ip" "wks_win11_pip" {
  count               = var.number_of_win11_wks
  name                = "wks-win11-pip-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = var.tags
}

resource "azurerm_network_interface" "wks_win11_nic" {
  count               = var.number_of_win11_wks
  depends_on          = [azurerm_public_ip.wks_win11_pip, var.workstation_subnet_id]
  name                = "wks-win11-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "wks-win11-ipconfig-${count.index}"
    subnet_id                     = var.workstation_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.wks_win11_pip.*.id, count.index)}"   # azurerm_public_ip.wks_win11_pip[count.index].id
  #  private_ip_address            = var.wks_ip
  }
}

resource "azurerm_windows_virtual_machine" "wks_win11" {
  count                           = var.number_of_win11_wks
  depends_on                      = [azurerm_network_interface.wks_win11_nic]
  name                            = "wks-win11-${count.index}" # "wks-${var.env_name}-${count.index}" "wks-win-wks-vm"
  location                        = var.location
  resource_group_name             = var.rg_name
  size                            = var.vm_size # "Standard_D4s_v4"
  computer_name                   = "wks-win11-${count.index}"
  admin_username                  = var.windows_username
  admin_password                  = var.windows_password
  network_interface_ids           = ["${element(azurerm_network_interface.wks_win11_nic.*.id, count.index)}"]
  custom_data = base64encode(file("${path.module}/files/winrm.ps1"))

  os_disk {
    caching                       = "ReadWrite"
    name                          = "wks-win11-osdisk-${count.index}"
    disk_size_gb                  = "250"
    storage_account_type          = "StandardSSD_LRS"
  #  create_option        = "FromImage"
  #  vhd_uri              = var.os_disk_vhd_uri
  }
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-ent"
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
    "kind"="workstation"
    "os"="windows"
    })
}

resource "azurerm_virtual_machine_extension" "wks_win11_vm_extension_network_watcher" {
  count                      = var.number_of_win11_wks
  depends_on                 = [azurerm_windows_virtual_machine.wks_win11]
  name                       = "win11netwatch${count.index}"
  virtual_machine_id         = "${element(azurerm_windows_virtual_machine.wks_win11.*.id, count.index )}"
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "wks_win11_vm_extension_bootstrap" {
  count                      = var.number_of_win11_wks
  depends_on                 = [azurerm_windows_virtual_machine.wks_win11]
  name                       = "win11postdeploy${count.index}"
  virtual_machine_id         = "${element(azurerm_windows_virtual_machine.wks_win11.*.id, count.index )}"
  publisher                  = "Microsoft.Compute" # "Microsoft.Azure.Extensions"
  type                       = "CustomScriptExtension" # "CustomScript"
  type_handler_version       = "1.9"
  #  auto_upgrade_minor_version = true
/*   settings = <<SETTINGS
  {
    "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.wks_powershell_command}\""
  }
SETTINGS
} */

/* settings = jsonencode({
  commandToExecute = "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.wks_powershell_command}\""
}) */

settings = local.wks_vm_extension_setting

}
