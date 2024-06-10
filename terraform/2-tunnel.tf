# Public IP for Virtual Network Gateway
resource "azurerm_public_ip" "pip_gw" {
    name                = "${var.environment}-gw-pip"
    location            = var.location
    resource_group_name = azurerm_resource_group.sc_rg.name
    allocation_method   = "Dynamic" #--Dynamic set means Azure will generate an IP for your Azure VPN Gateway
}

#-------------------------------
# Virtual Network Gateway 
#-------------------------------
resource "azurerm_virtual_network_gateway" "prisma_sc_vpng" {
    name                    = "${var.environment}-vpng"
    location                = var.location
    resource_group_name     = azurerm_resource_group.sc_rg.name
    type                    = "Vpn" 
    vpn_type                = "RouteBased" 
    enable_bgp              = var.enable_bgp
    sku                     = "VpnGw1"
    bgp_settings {
      asn             = var.bgp_asn_number
      peer_weight     = var.bgp_peer_weight
  }
    ip_configuration {
      name                          = "vnetGatewayConfig"
      public_ip_address_id          = azurerm_public_ip.pip_gw.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.transport_subnet.id
  }
  tags = local.common_tags
}

#---------------------------
# Local Network Gateway
#---------------------------
resource "azurerm_local_network_gateway" "localgw" {
    name                    = "${var.environment}-localgw"
    resource_group_name     = azurerm_resource_group.sc_rg.name
    location                = var.location
    gateway_address         = var.peer_network_gateway_address

  bgp_settings {
      asn                 = var.peer_bgp_settings_asn_number
      bgp_peering_address = var.peer_bgp_settings_peering_address
      peer_weight         = var.peer_bgp_settings_peer_weight
  }
  tags = local.common_tags
}



#---------------------------------------
# Virtual Network Gateway Connection
#---------------------------------------
resource "azurerm_virtual_network_gateway_connection" "az-hub-onprem" {
  name                            = "${var.environment}-vngconnect"
  resource_group_name             = azurerm_resource_group.sc_rg.name
  location                        = var.location
  type                            = var.gateway_connection_type
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.prisma_sc_vpng.id
  local_network_gateway_id        = azurerm_local_network_gateway.localgw.id
  
  enable_bgp                      = true
  shared_key                      = random_password.psk_gen.result
  connection_protocol             = var.gateway_connection_protocol

  ipsec_policy {
      dh_group         = var.peer_networks_ipsec_policy.dh_group
      ike_encryption   = var.peer_networks_ipsec_policy.ike_encryption
      ike_integrity    = var.peer_networks_ipsec_policy.ike_integrity
      ipsec_encryption = var.peer_networks_ipsec_policy.ipsec_encryption
      ipsec_integrity  = var.peer_networks_ipsec_policy.ipsec_integrity
      pfs_group        = var.peer_networks_ipsec_policy.pfs_group
      sa_datasize      = var.peer_networks_ipsec_policy.sa_datasize
      sa_lifetime      = var.peer_networks_ipsec_policy.sa_lifetime
  }
  tags = local.common_tags
}
