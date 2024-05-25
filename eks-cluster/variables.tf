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

variable "cluster_name" {
  type = string
  default = "k8s-cluster"
}

variable "kubernetes_version" {
  type    = string
  default = "1.27"
}