variable "location" {
  description = "Region where resources will be deployed."
  type        = string
}
variable "email" {
  description = "Please enter your email address here (Use output of `az ad signed-in-user show | jq .mail`)"
  type        = string
}
variable "tags" {
  description = "The tags to apply to the resources."
  type        = map(string)
  default = {}
}
variable "environment" {
  type        = string
  description = "Environment"
  default     = "AzurePrismaSC"
}

######NETWORK#######
variable "network_address_space" {
  type        = list(string)
  description = "Virtual Network Address Space"
}

variable "subnet_prefix" {
  type        = list(string)
  description = "Please enter the subnet prefix for use by the VM Subnet. Use proper CIDR format (e.g. 10.101.1.0/24)."
}
variable "transport_subnet_prefix" {
    description = "Please enter the subnet prefix for use by the GatewaySubnet. Use proper CIDR format (e.g. 10.101.1.0/24)."
    type        = list(string)
}
######COMPUTE###############
variable "vm_size" {
  type        = string
  description = "Enter the VM Size you would like to use for this deployment. This is normally specified in the tfvars file."
}
variable "number_of_ubuntu" {
  type        = number
  description = "Enter the number of Ubuntu VMs to deploy. This is normally specified in the tfvars file."
  default = 1
}
#--VPN Gateway
variable "vpn_gateway" {
    description = "VPN Gateway"
    type        = string
    default     = "local_vpn_gateway"
}

#--Peer VPN Gateway
variable "peer_vpn_gateway" {
    description = "Peer VPN Gateway"
    type        = string
    default     = "peer_vpn_gateway"
}

#--VPN Connection
variable "vpn_connection" {
    description = "VPN Connection"
    type        = string
    default     = "local_vpn_connection"
}

variable "enable_bgp" {
  type = bool
  description = "If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false"
}

variable "bgp_asn_number" {
  type = number
  description = "The Autonomous System Number (ASN) to use as part of the BGP. This value is for the Azure Virtual Network Gateway."
}

variable "bgp_peering_address" {
  description = "The BGP peer IP address of the virtual network gateway. This address is needed to configure the created gateway as a BGP Peer on the on-premises VPN devices. The IP address must be part of the subnet of the Virtual Network Gateway."
}

variable "bgp_peer_weight" {
  description = "The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100. This value is for the Azure Virtual Network Gateway."
}

variable "peer_network_gateway_name" {
  type = string
  description = "Enter the name for the Peer Gateway."
}

variable "peer_network_gateway_address" {
  type = string
  description = "Enter the IP Address for the Peer Gateway."
}

variable "peer_network_address_space" {
  type = list(string)
  description = "Enter the CIDR for the Peer Gateway."
}

variable "peer_bgp_settings_asn_number" {
  type = string
  description = "Enter the ASN of the Peer Gateway. This can be found in Prisma."
}

variable "peer_bgp_settings_peering_address" {
  type = string
  description = "Enter the IP Address of the Peer Gateway. This can be found in Prisma."
}

variable "peer_bgp_settings_peer_weight" {
  type = string
  description = "Enter the BGP Weight of the Peer Gateway. This can be found in Prisma."
}

variable "peer_networks_ipsec_policy" {
  type = object({ike_encryption = string, ike_integrity = string, dh_group = string, ipsec_encryption = string, ipsec_integrity = string, pfs_group = string, sa_datasize = number, sa_lifetime = number})
  description = "IPSec policy for local networks. Only a single policy can be defined for a connection."
  }
variable "gateway_connection_type" {
  description = "The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet)"
  default     = "IPsec"
}
variable "gateway_connection_protocol" {
  description = "The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2"
  default     = "IKEv2"
}

########LOCALS##############
locals {
  common_tags = merge(
    var.tags,
    {
      "Environment" = var.environment
    },
  )

  nsg_rules = {
    ingress_traffic = {
      name                           = "ingress_traffic"
      description                    = "Allow all internal Ingress Traffic"
      protocol                       = "*"
      source_address_prefixes         = "${var.subnet_prefix}"
      source_port_range              = "*"
      destination_address_prefix      = "${var.network_address_space}"
      destination_port_range         = "*"
      access                         = "Allow"
      priority                       = "131"
      direction                      = "Inbound"
  }
  
  ingress_vpn_traffic = {
      name                           = "vpn_ingress_traffic"
      description                    = "Allow all VPN Ingress Traffic"
      protocol                       = "*"
      source_address_prefixes         = ["10.0.1.0/24"] # Add appropriate vpn ingress traffic here. 
      source_port_range              = "*"
      destination_address_prefix      = "${var.network_address_space}"
      destination_port_range         = "*"
      access                         = "Allow"
      priority                       = "132"
      direction                      = "Inbound"
  }
}

}


#######SecurityGroupRules####
/* variable "nsg_rules" {
  type = list(object({
    name                       = string
    description                = string
    priority                   = string
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefixes    = list(string)
    destination_address_prefix = string
  }))
  description = "The values for each SG rule."
  default = []
} */