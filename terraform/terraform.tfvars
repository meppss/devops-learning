vm_size = "Standard_B2s_v2"

enable_bgp = true
bgp_asn_number = 65515
bgp_peering_address = "169.129.107.58"
bgp_peer_weight = 1

peer_network = {
    "gw_name" = "prisma_sc"
    "gateway_address" = "123.123.123.123"
    "address_space" = ["123.123.123.123/32"]
    "shared_key" = "random-shared-key"
}

peer_bgp_settings = {
    "asn_number" = 65510
    "peering_address" = "169.129.107.55"
    "peer_weight" = 1
}

peer_networks_ipsec_policy = {
    "ike_encryption" = "AES256"
    "ike_integrity" = "SHA256"
    "dh_group" = "DH2"
    "ipsec_encryption" = ""
    "ipsec_integrity" = ""
    "pfs_group" = ""
    "sa_datasize" = 123
    "sa_lifetime" = 123
  }
