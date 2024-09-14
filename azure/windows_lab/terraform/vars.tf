variable "location" {
  description = "Region where resources will be deployed."
  type        = string
  default     = "eastus"
}
variable "lab_id" {
  description = "The ID of the lab environment."
  type        = string
}
variable "tags" {
  description = "The tags to apply to the resources."
  type        = map(string)
  default = {
    "lab"         = "placeholder"
    "Team"        = "default-team"
    "Environment" = "default-environment"
}
}
variable "environment" {
  type        = string
  description = "Environment"
}

######NETWORK#######
variable "vnet_name" {
  type        = string
  description = "Virtual Network Name"
}

variable "network_address_space" {
  type        = string
  description = "Virtual Network Address Space"
}

variable "attacker_subnet_name" {
  type        = string
  description = "Attacker Subnet Name"
}

variable "attacker_subnet_prefix" {
  type        = list(any)
  description = "Attacker Subnet Address Prefix"
}
variable "server_subnet_name" {
  type        = string
  description = "Server Subnet Name"
}

variable "server_subnet_prefix" {
  type        = list(any)
  description = "Server Subnet Address Prefix"
}
variable "workstation_subnet_name" {
  type        = string
  description = "Workstation Subnet Name"
}

variable "workstation_subnet_prefix" {
  type        = list(any)
  description = "Workstation Subnet Address Prefix"
}

variable "control_subnet_name" {
  type        = string
  description = "Control Subnet Name"
}

variable "control_subnet_prefix" {
  type        = list(any)
  description = "Control Subnet Address Prefix"
}

variable "bastion_subnet_name" {
  type        = string
  description = "Bastion Subnet Name"
}

variable "bastion_subnet_prefix" {
  type        = list(any)
  description = "Bastion Subnet Address Prefix"
}

######COMPUTE###############
variable "vm_size" {
  type        = string
  description = "Enter the VM Size you would like to use for this deployment. This is normally specified in the tfvars file."
}
variable "create_bastion" {
  type = bool
  description = "Enter a boolean to create a Bastion host for this lab. This can be a 'true' or 'false' value. This is normally specified in the tfvars file"
}
variable "number_of_win_srv_2016" {
  type        = number
  description = "Enter the number of Windows Server 2016 instances to deploy. This is normally specified in the tfvars file."
}
variable "number_of_win_srv_2019" {
  type        = number
  description = "Enter the number of Windows Server 2019 instances to deploy. This is normally specified in the tfvars file."
}
variable "number_of_win_srv_2022" {
  type        = number
  description = "Enter the number of Windows Server 2022 instances to deploy. This is normally specified in the tfvars file."
}
variable "number_of_win10_wks" {
  type        = number
  description = "Enter the number of Windows 10 Workstations to deploy. This is normally specified in the tfvars file."
}
variable "number_of_win11_wks" {
  type        = number
  description = "Enter the number of Windows 11 Workstations to deploy. This is normally specified in the tfvars file."
}
variable "number_of_kali_attacker" {
  type        = number
  description = "Enter the number of Kali Linux Attacker VMs to deploy. This is normally specified in the tfvars file."
}
variable "number_of_commandovm_attacker" {
  type        = number
  description = "Enter the number of Commando VM Attacker VMs to deploy. This is normally specified in the tfvars file."
}

#####ACTIVE##DIRECTORY##DOMAIN##SERVICES######
variable "install_ad" {
  type        = bool
  description = "Enter a boolean to install Active Directory for this lab. This can be a 'true' or 'false' value. This is normally specified in the tfvars file."
}
variable "ad_domain_name" {
  type        = string
  description = "Enter the domain name for Active Directory. This is normally specified in the tfvars file."
}
variable "ad_domain_netbios_name" {
  type        = string
  description = "Enter the NetBIOS name for Active Directory. This is normally specified in the tfvars file."
}
variable "number_of_win_srv_2016_ad" {
  type        = number
  description = "Enter the number of AD Connected Windows Server 2016 instances to deploy. This is normally specified in the tfvars file."
}
variable "number_of_win_srv_2019_ad" {
  type        = number
  description = "Enter the number of AD Connected Windows Server 2019 instances to deploy. This is normally specified in the tfvars file."
}
variable "number_of_win_srv_2022_ad" {
  type        = number
  description = "Enter the number of AD Connected Windows Server 2022 instances to deploy. This is normally specified in the tfvars file."
}
variable "number_of_win10_wks_ad" {
  type        = number
  description = "Enter the number of AD Connected Windows 10 Workstations to deploy. This is normally specified in the tfvars file."
}
variable "number_of_win11_wks_ad" {
  type        = number
  description = "Enter the number of AD Connected Windows 11 Workstations to deploy. This is normally specified in the tfvars file."
}
######STORAGE###############
