resource "azurerm_network_interface" "ubuntu_nic" {
  count               = var.number_of_ubuntu
  depends_on          = [azurerm_subnet.vm_subnet]
  name                = "ubuntu-nic-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.sc_rg.name
  ip_configuration {
    name                          = "ubuntu-ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "ubuntu" {
  count                           = var.number_of_ubuntu
  depends_on                      = [azurerm_network_interface.ubuntu_nic]
  name                            = "ubuntu-${count.index}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.sc_rg.name
  size                            = var.vm_size
  computer_name                   = "ubuntu-${count.index}"
  network_interface_ids           = ["${element(azurerm_network_interface.ubuntu_nic.*.id, count.index)}"]
  admin_username                  = "ubuntu"
  os_disk {
    caching                       = "ReadWrite"
    name                          = "ubuntu-osdisk-${count.index}"
    disk_size_gb                  = "250"
    storage_account_type          = "StandardSSD_LRS"
  }
  admin_ssh_key {
    username  = "ubuntu"
    public_key = tls_private_key.ubuntu_ssh_key.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = local.common_tags
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "ubuntu_autoshutdown" {
  count                 = var.number_of_ubuntu
  virtual_machine_id    = "${element(azurerm_linux_virtual_machine.ubuntu.*.id, count.index )}"
  location              = var.location
  enabled               = true

  daily_recurrence_time = "1830"
  timezone              = "Pacific Standard Time"
  notification_settings {
    enabled             = true
    time_in_minutes     = "60"
    email               = "${var.email}"
  }
}
