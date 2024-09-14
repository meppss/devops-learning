resource "azurerm_public_ip" "attacker_kali_public_ip" {
  count               = var.number_of_kali_attacker
  name                = "att-kali-pip-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = var.tags
}

resource "azurerm_network_interface" "attacker_kali_nic" {
  count               = var.number_of_kali_attacker
  depends_on          = [azurerm_public_ip.attacker_kali_public_ip, var.attacker_subnet_id]
  name                = "att-kali-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "att-kali-ipconfig-${count.index}"
    subnet_id                     = var.attacker_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.attacker_kali_public_ip.*.id, count.index)}"   # azurerm_public_ip.attacker_nic_kali_public_ip[count.index].id
  #  private_ip_address            = var.attacker_ip
  }
}

resource "azurerm_linux_virtual_machine" "attacker_kali" {
  count                           = var.number_of_kali_attacker
  depends_on                      = [azurerm_network_interface.attacker_kali_nic, var.kali_cloudinit_filename]
  name                            = "att-kali-${count.index}" # "attacker-${var.env_name}-${count.index}" "attacker-win-attacker-vm"
  location                        = var.location
  resource_group_name             = var.rg_name
  size                            = var.vm_size # "Standard_D4s_v4"
  computer_name                   = "att-kali-${count.index}"
  network_interface_ids           = ["${element(azurerm_network_interface.attacker_kali_nic.*.id, count.index)}"]
  admin_username                  = "kali"
  # admin_password                  = "Azureuser123!"
  # disable_password_authentication = false
  # custom_data = base64encode("${path.module}/../storage/files/kali_cloud_init.cfg")
  # custom_data = base64encode(file(var.kali_cloudinit_filename))
  custom_data = base64encode(templatefile("${path.module}/../storage/baseline/kali_cloud_init.tftpl",
    { 
      "SA_NAME"         = "${var.sa_name}",
      "SA_ACCESS_KEY"   = "${var.sa_primary_access_key}",
      "FILESHARE_NAME"  = "${var.fileshare_name}",
      "ADMIN_PASS"      = "${var.windows_password}"
    }))
  os_disk {
    caching                       = "ReadWrite"
    name                          = "att-kali-osdisk-${count.index}"
    disk_size_gb                  = "250"
    storage_account_type          = "StandardSSD_LRS"
  }
  admin_ssh_key {
    username  = "kali"
    public_key = file("./modules/compute/ssh/attacker-kali.pub")
  }

  source_image_reference {
    publisher = "kali-linux"
    offer     = "kali"
    sku       = "kali"
    version   = "latest"
  }
  plan {
    name = "kali"
    product = "kali"
    publisher = "kali-linux"
  }

  tags = merge(var.tags,
    {
    "kind"="attacker"
    "os"="linux"
    })
}

/* resource "azurerm_virtual_machine_extension" "att_kali_vm_extension_bootstrap" {
  count                      = var.number_of_kali_attacker
  depends_on                 = [azurerm_linux_virtual_machine.attacker_kali]
  name                       = "kalipostdeploy${count.index}"
  virtual_machine_id         = "${element(azurerm_linux_virtual_machine.attacker_kali.*.id, count.index )}"
  publisher                  = "Microsoft.Azure.Extensions" # "Microsoft.Azure.Extensions"
  type                       = "CustomScript" # "CustomScript"
  type_handler_version       = "2.0"
  #  auto_upgrade_minor_version = true
  settings = local.att_kali_vm_extension_setting
} */
