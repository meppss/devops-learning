variable "region" {
  description = "The AWS region you want to deploy resources into. "
  type = string
  default = "us-east-2"
}

variable "cidr_block" {
  description = "The CIDR you want specified for the VPC."
  type = string
  default = "10.0.0.0/16"
}
variable "tags" {
  description = "The tags to apply to the resources."
  type        = map(string)
  default = {
    "Environment" = "k8s-demo"
  }
}

variable "key_pair_name" {
  description = "key_pair_name"
  type        = string
  default = "mongodb-instance"
}

variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources"
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.27"
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) to associate with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU."
  type = string 
  default = "AL2_x86_64"
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes. Defaults to 20."
  type = number
  default = 20
}

variable "instance_types" {
  type = list(string)
  default = ["t3.medium"]
  description = "Set of instance types associated with the EKS Node Group."
}

locals {
  mongo_username = "webapp-user"
  mongo_pass = "CABLE-disorder-crybaby-compline-shyly"
  mongo_private_ip = "10.0.1.20"
  name = "k8s-config"
}

/*
variable "node_group_default_disk_size" {
  description = "Default size of EBS volume to attach to each EC2 intance in the node group"
  type	= string
  default = "30"
}

variable "node_group_default_instance_type" {
  description = "Default EC2 instance type for the node group"
  type  = string
  default = "t3.medium"
}

variable "node_group_desired_capacity" {
  description = "The desired number of EC2 instances in the node group"
  type  = string
  default = "1"
}

variable "node_group_min_capacity" {
  description = "The minimum number of EC2 instances in the node group at a given time"
  type  = string
  default = "1"
}

variable "node_group_max_capacity" {
  description = "The maximum number of EC2 instances in the node group at a given time. Used when auto scaling is enabled"
  type  = string
  default = "3"
}
*/
