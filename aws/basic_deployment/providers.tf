terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.28.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  # Configuration options
  region = var.location
}
