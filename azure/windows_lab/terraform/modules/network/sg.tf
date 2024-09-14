# NSG Association Resources
resource "azurerm_subnet_network_security_group_association" "attacker-sga" {
  subnet_id                 = azurerm_subnet.attacker_subnet.id
  network_security_group_id = azurerm_network_security_group.attacker-sg.id
}
resource "azurerm_subnet_network_security_group_association" "server-sga" {
  subnet_id                 = azurerm_subnet.server_subnet.id
  network_security_group_id = azurerm_network_security_group.server-sg.id
}
resource "azurerm_subnet_network_security_group_association" "workstation-sga" {
  subnet_id                 = azurerm_subnet.workstation_subnet.id
  network_security_group_id = azurerm_network_security_group.workstation-sg.id
}
resource "azurerm_subnet_network_security_group_association" "control-sga" {
  subnet_id                 = azurerm_subnet.control_subnet.id
  network_security_group_id = azurerm_network_security_group.control-sg.id
}
resource "azurerm_subnet_network_security_group_association" "bastion-sga" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.bastion-sg.id
  depends_on                = [
    azurerm_network_security_group.bastion-sg
    
  ]
}

################################
resource "azurerm_network_security_group" "attacker-sg" {
  name = "${var.environment}-attacker-sg"
  location = var.location
  resource_group_name = var.rg_name
  tags = var.tags
  
  dynamic security_rule {
    for_each = var.sg_rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefixes     = security_rule.value["source_address_prefixes"]
      destination_address_prefix  = security_rule.value["destination_address_prefix"]
    }
  }
}

resource "azurerm_network_security_group" "server-sg" {
  name = "${var.environment}-server-sg"
  location = var.location
  resource_group_name = var.rg_name
  tags = var.tags
  
  dynamic security_rule {
    for_each = var.sg_rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefixes     = security_rule.value["source_address_prefixes"]
      destination_address_prefix  = security_rule.value["destination_address_prefix"]
    }
  }
}
resource "azurerm_network_security_group" "workstation-sg" {
  name = "${var.environment}-workstation-sg"
  location = var.location
  resource_group_name = var.rg_name
  tags = var.tags
  
  dynamic security_rule {
    for_each = var.sg_rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefixes     = security_rule.value["source_address_prefixes"]
      destination_address_prefix  = security_rule.value["destination_address_prefix"]
    }
  }
}

resource "azurerm_network_security_group" "control-sg" {
  name = "${var.environment}-control-sg"
  location = var.location
  resource_group_name = var.rg_name
  tags = var.tags
  
  dynamic security_rule {
    for_each = var.sg_rules_control
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefixes     = security_rule.value["source_address_prefixes"]
      destination_address_prefix  = security_rule.value["destination_address_prefix"]
    }
  }
}

resource "azurerm_network_security_group" "bastion-sg" {
  name = "${var.environment}-bastion-sg"
  location = var.location
  resource_group_name = var.rg_name
  tags = var.tags
  
  dynamic security_rule {
    for_each = var.sg_rules_bastion
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix       = security_rule.value["source_address_prefix"]
      destination_address_prefix  = security_rule.value["destination_address_prefix"]
    }
  }
}
################################
/* resource "azurerm_network_security_group" "nsg" {
  for_each = var.subnets

  name                = "nsg-${each.value.subnet_name}"
  resource_group_name = var.rg_name
  location            = var.location
  dynamic "security_rule" {
    for_each = lookup(each.value, "nsg_rules", [])
    content {
      name                       = security_rule.value[0] == "" ? "Default_Rule" : security_rule.value[0]
      priority                   = security_rule.value[1]
      direction                  = security_rule.value[2] == "" ? "Inbound" : security_rule.value[2]
      access                     = security_rule.value[3] == "" ? "Allow" : security_rule.value[3]
      protocol                   = security_rule.value[4] == "" ? "Tcp" : security_rule.value[4]
      source_port_range          = "*"
      destination_port_ranges    = security_rule.value[5] == "" ? "*" : security_rule.value[5]
      source_address_prefix      = security_rule.value[6] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[6]
      destination_address_prefix = security_rule.value[7] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[7]
      description                = "${security_rule.value[2]}_Port_${security_rule.value[5]}"
    }
  }
} */

