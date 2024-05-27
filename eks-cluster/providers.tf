terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.51.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
    local= {
      source = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

provider "aws" {
    region = var.region
}
provider "tls" {}
provider "local" {}
