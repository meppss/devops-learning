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
  type = string
  default = "batman"
}

variable "kubernetes_version" {
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
