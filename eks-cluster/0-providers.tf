terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.51.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.13.2"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
    local= {
      source = "hashicorp/local"
      version = "2.5.1"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "aws" {
    region = var.region
}
provider "tls" {}
provider "local" {}
provider "template" {}
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  }
}
