resource "azurerm_storage_account" "lab_sa" {
  name                     = "tfsta${var.sta_random_id_hex}" #random_pet.storage_name.keepers.name #   "${var.sa_name}storage"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_kind             = "StorageV2" 
  account_tier             = "Standard"
  account_replication_type = "LRS"
  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = "10"
    }
    hour_metrics {
        enabled               = true
        include_apis          = true
        version               = "1.0"
        retention_policy_days = 10
    }
    minute_metrics {
        enabled               = true
        include_apis          = true
        version               = "1.0"
        retention_policy_days = 10
    }
  }
  tags                     = var.tags
}

resource "azurerm_storage_container" "lab_sa_container" {
  name                  = "container${var.sta_random_id_hex}" #"${var.sa_name}-container"
  storage_account_name  = azurerm_storage_account.lab_sa.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "lab_sa_blob" {
  name                   = "blob${var.sta_random_id_hex}" #"${var.sa_name}-blob"
  storage_account_name   = azurerm_storage_account.lab_sa.name
  storage_container_name = azurerm_storage_container.lab_sa_container.name
  type                   = "Block"
  access_tier            = "Hot"
}

resource "azurerm_storage_share" "lab_sa_share" {
  name                 = "fileshare${var.sta_random_id_hex}" #"${var.sa_name}-fileshare"  
  storage_account_name = azurerm_storage_account.lab_sa.name
  quota                = 50
  access_tier          = "TransactionOptimized"
  enabled_protocol     = "SMB"
}

resource "azurerm_storage_share_file" "lab_fileshare_mount_file" {
  depends_on = [local_file.win_fileshare_mount_create]
  name             = "win_fileshare_mount.ps1"
  storage_share_id = azurerm_storage_share.lab_sa_share.id
  source           = "${path.module}/files/win_fileshare_mount.ps1"
  content_type     = "text/plain"
}
