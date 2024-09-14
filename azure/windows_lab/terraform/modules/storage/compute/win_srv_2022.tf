resource "azurerm_public_ip" "srv_win_2022_pip" {
  count               = var.number_of_win_srv_2022
  name                = "srv-win-2022-pip-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = var.tags
}

resource "azurerm_network_interface" "nic_srv_win_2022" { 
  count               = var.number_of_win_srv_2022
  depends_on          = [azurerm_public_ip.srv_win_2022_pip, var.server_subnet_id]
  name                = "srv-win-2022-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "srv-win-2022-ipconfig-${count.index}"
    subnet_id                     = var.server_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.srv_win_2022_pip.*.id, count.index)}"   # azurerm_public_ip.srv_win_2022_pip[count.index].id
  #  private_ip_address            = var.server_ip
  }
}

resource "azurerm_windows_virtual_machine" "srv_win_2022" {
  count                           = var.number_of_win_srv_2022
  depends_on                      = [azurerm_network_interface.nic_srv_win_2022]
  name                            = "srv-win-2022-${count.index}" # "server-${var.env_name}-${count.index}" "server-win-wkst-vm"
  location                        = var.location
  resource_group_name             = var.rg_name
  size                            = var.vm_size # "Standard_D4s_v4"
  computer_name                   = "srv-win-2022-${count.index}"
  admin_username                  = var.windows_username
  admin_password                  = var.windows_password
  network_interface_ids           = ["${element(azurerm_network_interface.nic_srv_win_2022.*.id, count.index)}"]
  custom_data = base64encode(file("${path.module}/files/winrm.ps1"))

  os_disk {
    caching                       = "ReadWrite"
    name                          = "srv-win-2022-osdisk-${count.index}"
    disk_size_gb                  = "250"
    storage_account_type          = "StandardSSD_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
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
    "kind"="server"
    "os"="windows"
    })
}

resource "azurerm_virtual_machine_extension" "srv_2022_vm_extension_network_watcher" {
  count                      = var.number_of_win_srv_2022
  depends_on                 = [azurerm_windows_virtual_machine.srv_win_2022]
  name                       = "srvwin2022netwatch${count.index}"
  virtual_machine_id         = "${element(azurerm_windows_virtual_machine.srv_win_2022.*.id, count.index )}"
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "srv_2022_vm_extension_bootstrap" {
  count                      = var.number_of_win_srv_2022
  depends_on                 = [azurerm_windows_virtual_machine.srv_win_2022]
  name                       = "srv2022postdeploy${count.index}"
  virtual_machine_id         = "${element(azurerm_windows_virtual_machine.srv_win_2022.*.id, count.index )}"
  publisher                  = "Microsoft.Compute" # "Microsoft.Azure.Extensions"
  type                       = "CustomScriptExtension" # "CustomScript"
  type_handler_version       = "1.9"
  #  auto_upgrade_minor_version = true
/*   settings = <<SETTINGS
  {
    "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.srv_powershell_command}\""
  }
SETTINGS
} */

/* settings = jsonencode({
  commandToExecute = "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"${local.srv_powershell_command}\""
}) */

settings = local.srv_vm_extension_setting

}
