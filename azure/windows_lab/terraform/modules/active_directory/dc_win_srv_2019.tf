/* resource "azurerm_public_ip" "dc_srv_win_2019_pip" {
  count                           = var.install_ad == true ? 1 : 0
  name                            = "${local.dc_prefix}-pip-${count.index}"
  location                        = var.location
  resource_group_name             = var.rg_name
  allocation_method               = "Static"
  sku                             = "Standard"
  tags = var.tags
} */
resource "azurerm_network_interface" "dc_srv_win_2019_nic" { 
  count                           = var.install_ad == true ? 1 : 0
#  depends_on                      = [azurerm_public_ip.dc_srv_win_2019_pip, var.server_subnet_id]
  depends_on                      = [var.server_subnet_id]
  name                            = "${local.dc_prefix}-nic-${count.index}"
  location                        = var.location
  resource_group_name             = var.rg_name
  ip_configuration {
    name                          = "${local.dc_prefix}-ipconfig-${count.index}"
    subnet_id                     = var.server_subnet_id
    private_ip_address_allocation = "Dynamic"
  #  public_ip_address_id          = "${element(azurerm_public_ip.dc_srv_win_2019_pip.*.id, count.index)}"   # azurerm_public_ip.dc_srv_win_2019_pip[count.index].id
  #  private_ip_address            = var.server_ip
  }
}

resource "azurerm_windows_virtual_machine" "dc_srv_win_2019" {
  count                           = var.install_ad == true ? 1 : 0
  depends_on                      = [azurerm_network_interface.dc_srv_win_2019_nic]
  name                            = "${local.dc_prefix}-${count.index}" # "server-${var.env_name}-${count.index}" "server-win-wkst-vm"
  location                        = var.location
  resource_group_name             = var.rg_name
  size                            = var.vm_size # "Standard_D4s_v4"
  computer_name                   = "${local.dc_prefix}-${count.index}"
  admin_username                  = var.ad_username
  admin_password                  = var.windows_password
  network_interface_ids           = ["${element(azurerm_network_interface.dc_srv_win_2019_nic.*.id, count.index)}"]
  custom_data                     = base64encode(file("${local.winrm_file}"))

  os_disk {
    caching                       = "ReadWrite"
    name                          = "${local.dc_prefix}-osdisk-${count.index}"
    disk_size_gb                  = "250"
    storage_account_type          = "StandardSSD_LRS"
  #  create_option        = "FromImage"
  #  vhd_uri              = var.os_disk_vhd_uri
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  additional_unattend_content {
    setting = "AutoLogon"
    content = local.auto_logon_data_ad
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
    "ad-role" = "domain-controller"
    "kind"="server"
    "os"="windows"
    })
}

resource "azurerm_virtual_machine_extension" "dc_srv_2019_vm_extension_network_watcher" {
  count                      = var.install_ad == true ? 1 : 0
  depends_on                 = [azurerm_windows_virtual_machine.dc_srv_win_2019]
  name                       = "srvwin2019-dc-netwatch${count.index}"
  virtual_machine_id         = "${element(azurerm_windows_virtual_machine.dc_srv_win_2019.*.id, count.index )}"
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "dc_srv_2019_vm_extension_bootstrap" {
  count                      = var.install_ad == true ? 1 : 0
  depends_on                 = [azurerm_windows_virtual_machine.dc_srv_win_2019]
  name                       = "srvwin2019-dc-postdeploy${count.index}"
  virtual_machine_id         = "${element(azurerm_windows_virtual_machine.dc_srv_win_2019.*.id, count.index )}"
  publisher                  = "Microsoft.Compute" # "Microsoft.Azure.Extensions"
  type                       = "CustomScriptExtension" # "CustomScript"
  type_handler_version       = "1.9"
  #  auto_upgrade_minor_version = true
  settings = local.srv_vm_extension_setting_install_ad
}
