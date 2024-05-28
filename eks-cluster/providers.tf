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
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"

  host                   = aws_eks_cluster.k8s-demo-eks-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.k8s-demo-eks-cluster.certificate_authority.0.data)
}
provider "tls" {}
provider "local" {}
provider "template" {}
