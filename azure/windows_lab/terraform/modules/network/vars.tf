variable "location" {}
variable "network_address_space" {}
variable "attacker_subnet_name" {}
variable "attacker_subnet_prefix" {}
variable "server_subnet_name" {}
variable "server_subnet_prefix" {}
variable "workstation_subnet_name" {}
variable "workstation_subnet_prefix" {}
variable "control_subnet_name" {}
variable "control_subnet_prefix" {}
variable "bastion_subnet_name" {}
variable "bastion_subnet_prefix"{}
variable "environment" {
  default = "lab-default"
}
variable "rg_name" {}
variable "vnet_name" {
  default = "lab-vnet"
}
variable "tags" {
  description = "The tags to apply to the resources."
  type        = map(string)  
}
variable "vpn_ip_address" {
  default = ["{INSERT_CIDR1}", "{INSERT_CIDR2}"]
}
variable "sa_id" {}
variable "sta_random_id_hex" {}
variable "fileshare_id" {}


#####ACTIVE###DIRECTORY#####
variable "install_ad" {}
variable "dc_srv_2019_ip" {}

#######SecurityGroups########
variable "sg_rules" {
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
  default = [
  /*
  {
    name                           = "ingress_ssh"
    description                    = "ssh ingress access"
    protocol                       = "Tcp"
    source_address_prefixes         = ["10.0.0.0/24"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.0.0/20"
    destination_port_range         = "22"
    access                         = "Allow"
    priority                       = "100"
    direction                      = "Inbound"
  },
  */
  {
    name                           = "ingress_ssh_vpn1"
    description                    = "ssh ingress access"
    protocol                       = "Tcp"
    source_address_prefixes         = ["{INSERT_CIDR}"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.0.0/20"
    destination_port_range         = "22"
    access                         = "Allow"
    priority                       = "101"
    direction                      = "Inbound"
  },
  {
    name                           = "ingress_ssh_vpn2"
    description                    = "ssh ingress access"
    protocol                       = "Tcp"
    source_address_prefixes         = ["{INSERT_CIDR}"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.0.0/20"
    destination_port_range         = "22"
    access                         = "Allow"
    priority                       = "102"
    direction                      = "Inbound"
  },
  /*
  {
    name                           = "ingress_http"
    description                    = "http ingress access"
    protocol                       = "Tcp"
    source_address_prefixes         = ["10.0.0.0/24"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.0.0/20"
    destination_port_range         = "80"
    access                         = "Allow"
    priority                       = "110"
    direction                      = "Inbound"
  },
  {
    name                           = "ingress_https"
    description                    = "https ingress access"
    protocol                       = "Tcp"
    source_address_prefixes         = ["10.0.0.0/24"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.0.0/20"
    destination_port_range         = "443"
    access                         = "Allow"
    priority                       = "120"
    direction                      = "Inbound"
  },
  {
    name                           = "ingress_rdp"
    description                    = "RDP ingress access"
    protocol                       = "Tcp"
    source_address_prefixes         = ["10.0.0.0/24"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.0.0/20"
    destination_port_range         = "3389"
    access                         = "Allow"
    priority                       = "130"
    direction                      = "Inbound"
  },
  */
  {
    name                           = "ingress_lab_traffic"
    description                    = "Allow all Lab Ingress Traffic"
    protocol                       = "*"
    source_address_prefixes         = ["10.0.0.0/20"] # ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24","10.0.5.0/24"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.0.0/20"
    destination_port_range         = "*"
    access                         = "Allow"
    priority                       = "131"
    direction                      = "Inbound"
  }
  ]
}

variable "sg_rules_bastion" {
  type = list(object({
    name                       = string
    description                = string
    priority                   = string
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix       = string
    destination_address_prefix  = string
  }))
  description = "The values for each Bastion SG rule."
  default = [
  {
    name                           = "AllowHttpsInbound"
    description                    = "allow ingress traffic from public internet"
    protocol                       = "Tcp"
    source_address_prefix           = "Internet"
    source_port_range              = "*"
    destination_address_prefix      = "*"
    destination_port_range         = "443"
    access                         = "Allow"
    priority                       = "100"
    direction                      = "Inbound"
  },  
  {
    name                           = "AllowGatewayManagerInbound"
    description                    = "allow ingress traffic from Azure Bastion control plane"
    protocol                       = "Tcp"
    source_address_prefix           = "GatewayManager"
    source_port_range              = "*"
    destination_address_prefix      = "*"
    destination_port_range         = "443"
    access                         = "Allow"
    priority                       = "110"
    direction                      = "Inbound"
  },
  {
    name                           = "AllowAzureLoadBalancerInbound"
    description                    = "allow ingress traffic from Azure Bastion load balancer for health probes"
    protocol                       = "Tcp"
    source_address_prefix           = "AzureLoadBalancer"
    source_port_range              = "*"
    destination_address_prefix      = "*"
    destination_port_range         = "443"
    access                         = "Allow"
    priority                       = "120"
    direction                      = "Inbound"
  },
  {
    name                           = "AllowBastionHostCommunication_1"
    description                    = "Enables Azure Bastion service communications"
    protocol                       = "*"
    source_address_prefix           = "VirtualNetwork"
    source_port_range              = "*"
    destination_address_prefix      = "VirtualNetwork"
    destination_port_range         = "8080"
    access                         = "Allow"
    priority                       = "121"
    direction                      = "Inbound"
  },
  {
    name                           = "AllowBastionHostCommunication_2"
    description                    = "Enables Azure Bastion service communications"
    protocol                       = "*"
    source_address_prefix           = "VirtualNetwork"
    source_port_range              = "*"
    destination_address_prefix      = "VirtualNetwork"
    destination_port_range         = "5701"
    access                         = "Allow"
    priority                       = "122"
    direction                      = "Inbound"
  },
  {
    name                           = "AllowSshOutbound"
    description                    = "allow egress traffic from Azure Bastion to private subnets using ssh"
    protocol                       = "Tcp"
    source_address_prefix           = "*"
    source_port_range              = "*"
    destination_address_prefix      = "VirtualNetwork"
    destination_port_range         = "22"
    access                         = "Allow"
    priority                       = "130"
    direction                      = "Outbound"
  },
  {
    name                           = "AllowRdpOutbound"
    description                    = "allow egress traffic from Azure Bastion to private subnets using rdp"
    protocol                       = "Tcp"
    source_address_prefix           = "*"
    source_port_range              = "*"
    destination_address_prefix      = "VirtualNetwork"
    destination_port_range         = "3389"
    access                         = "Allow"
    priority                       = "140"
    direction                      = "Outbound"
  },
  {
    name                           = "AllowAzureCloudOutbound"
    description                    = "allow egress traffic from Azure Bastion to Azure Endpoints"
    protocol                       = "Tcp"
    source_address_prefix           = "*"
    source_port_range              = "*"
    destination_address_prefix      = "AzureCloud"
    destination_port_range         = "443"
    access                         = "Allow"
    priority                       = "150"
    direction                      = "Outbound"
  },
  {
    name                           = "AllowBastionCommunication_1"
    description                    = "allow egress traffic from Azure Bastion to Azure Bastion Data Plane"
    protocol                       = "*"
    source_address_prefix           = "VirtualNetwork"
    source_port_range              = "*"
    destination_address_prefix      = "VirtualNetwork"
    destination_port_range         = "8080"
    access                         = "Allow"
    priority                       = "160"
    direction                      = "Outbound"
  },
  {
    name                           = "AllowBastionCommunication_2"
    description                    = "allow egress traffic from Azure Bastion to Azure Bastion Data Plane"
    protocol                       = "*"
    source_address_prefix           = "VirtualNetwork"
    source_port_range              = "*"
    destination_address_prefix      = "VirtualNetwork"
    destination_port_range         = "5701"
    access                         = "Allow"
    priority                       = "170"
    direction                      = "Outbound"
  },
  {
    name                           = "AllowGetSessionInformation"
    description                    = "allow egress traffic from Azure Bastion to Internet for session and certificate validation"
    protocol                       = "*"
    source_address_prefix           = "*"
    source_port_range              = "*"
    destination_address_prefix      = "Internet"
    destination_port_range         = "80"
    access                         = "Allow"
    priority                       = "180"
    direction                      = "Outbound"
  }
]
}

variable "sg_rules_control" {
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
  default = [
  {
    name                           = "ingress_ssh"
    description                    = "bastion ssh ingress access"
    protocol                       = "Tcp"
    source_address_prefixes         = ["10.0.0.0/24"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.1.0/24"
    destination_port_range         = "22"
    access                         = "Allow"
    priority                       = "100"
    direction                      = "Inbound"
  },
  {
    name                           = "ingress_rdp"
    description                    = "bastion RDP ingress access"
    protocol                       = "Tcp"
    source_address_prefixes         = ["10.0.0.0/24"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.1.0/24"
    destination_port_range         = "3389"
    access                         = "Allow"
    priority                       = "101"
    direction                      = "Inbound"
  },
  {
    name                           = "ingress_smb"
    description                    = "SMB ingress access for File Share access"
    protocol                       = "Tcp"
    source_address_prefixes         = ["10.0.0.0/20"]
    source_port_range              = "*"
    destination_address_prefix      = "10.0.1.0/24"
    destination_port_range         = "445"
    access                         = "Allow"
    priority                       = "102"
    direction                      = "Inbound"
  }
  ]
}
