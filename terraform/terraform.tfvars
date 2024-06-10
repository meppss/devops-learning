location        = "eastus"
vm_size         = "Standard_B2s_v2"


###AzureBGPSettings###
enable_bgp = true
bgp_asn_number = 65515
# bgp_peering_address = "123.123.123.123"
bgp_peer_weight = 1


###PeerBGPSettings###
peer_bgp_settings_asn_number = 65534
# peer_bgp_settings_peering_address = "120.120.120.120"
peer_bgp_settings_peer_weight = 1
peer_networks_ipsec_policy = {
    "ike_encryption"    = "AES256"
    "ike_integrity"     = "SHA256"
    "dh_group"          = "DHGroup2"
    "ipsec_encryption"  = "AES256"
    "ipsec_integrity"   = "SHA256"
    "pfs_group"         = "PFS2"
    "sa_datasize"       = 102400000
    "sa_lifetime"       = 3600
  }


#####Networking#########
network_address_space   = [ "10.101.0.0/16" ]
subnet_prefix           = [ "10.101.1.0/24" ]
transport_subnet_prefix = [ "10.101.0.0/24" ]
