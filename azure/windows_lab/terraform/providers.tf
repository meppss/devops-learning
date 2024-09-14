terraform {
  # Configure the Azure provider
  required_version = ">= 1.3.9"
  backend "azurerm" {
    resource_group_name = "lab-resources-rg"  
    storage_account_name = "statestorage"
    container_name = "tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.3.0"
    }
    time = {
      source = "hashicorp/time"
      version = "0.9.1"
    }
  }
}
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    virtual_machine {
      delete_os_disk_on_deletion  = true
      graceful_shutdown = false
      skip_shutdown_and_force_delete = false
    }
  }
}

provider "random" {
  # Configuration options
}

provider "null" {
  # Configuration options
}

provider "local" {
  # Configuration options
}

provider "time" {
  # Configuration options
}
