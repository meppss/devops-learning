resource "azurerm_public_ip" "bastion_nic_public_ip" {
  depends_on          = [var.bastion_sga, var.bastion_subnet_id]
  count               = var.create_bastion == true ? 1 : 0
  name                = "${var.environment}-bastion-host-pip-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "azbastion_host" {
  depends_on             = [var.rg_name, azurerm_public_ip.bastion_nic_public_ip]
  count                  = var.create_bastion == true ? 1 : 0
  name                   = "${var.environment}-bastion-host-${count.index}"
  location               = var.location
  resource_group_name    = var.rg_name
  sku                    = "Standard"
  tags                   = var.tags
  ip_configuration {
    name                 = "${var.environment}-bastion-ipconfig"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = "${element(azurerm_public_ip.bastion_nic_public_ip.*.id, count.index)}"    
  }
}
