variable "location" {}
variable "environment" {
  default = "lab-default"
}
variable "rg_name" {}
variable "tags" {
  description = "The tags to apply to the resources."
  type        = map(string)  
}
variable "attacker_subnet_id" {}
variable "server_subnet_id" {}
variable "workstation_subnet_id" {}
variable "control_subnet_id" {}
# variable "subnet_ids" {}
variable "sta_random_id_hex" {}
variable "admin_password" {}
