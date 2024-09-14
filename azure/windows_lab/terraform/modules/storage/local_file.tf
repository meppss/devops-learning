locals {
  win_fileshare_script_path     = "${path.module}/files/win_fileshare_mount.ps1"
  linux_fileshare_script_path   = "${path.module}/files/linux_fileshare_mount.sh"
  remove_file_command           = "rm $FILE"
  create_file_command           = "echo '${local.fileshare_local_bash}' >> $FILE"
  # fileshare_local_bash_path    = "\\\\${local.privatelink_fqdn}\\${var.fileshare_name}"
  fileshare_local_bash_path     = "\\\\${local.privatelink_fqdn}\\${local.fileshare_name}"
  fileshare_local_bash          = "net use S: ${local.fileshare_local_bash_path} /user:${azurerm_storage_account.lab_sa.name} \"${azurerm_storage_account.lab_sa.primary_access_key}\""
  sa_primary_access_key        = azurerm_storage_account.lab_sa.primary_access_key
  sa_name                      = azurerm_storage_account.lab_sa.name
  fileshare_name                = azurerm_storage_share.lab_sa_share.name
  privatelink_fqdn             = "${local.sa_name}.privatelink.file.core.windows.net"

  fileshare_file_name            = "win_fileshare_mount.ps1"
  fileshare_path                = "\\\\${local.privatelink_fqdn}\\${local.fileshare_name}"
  fileshare_script_path_upload  = "${local.fileshare_path}\\${local.fileshare_file_name}"
  copy_source                  = "\\\\${local.privatelink_fqdn}\\${azurerm_storage_share.lab_sa_share.name}\\${local.fileshare_file_name}"
  copy_destination             = "C:\\terraform"
}

resource "local_file" "win_fileshare_mount_create" {
  filename = "${path.module}/files/win_fileshare_mount.ps1"
  content = templatefile("${path.module}/baseline/win_fileshare_mount.tftpl", 
      { 
        "remote_path" = "${local.fileshare_local_bash_path}", 
        "sa_name"       = "${local.sa_name}", 
        "sa_access_key" = "${local.sa_primary_access_key}" 
      } ) # "file(${path.module}/baseline/win_fileshare_mount.tftpl)"
}

resource "local_file" "linux_fileshare_mount_create" {
  filename = "${path.module}/files/linux_fileshare_mount.sh"
  content = templatefile("${path.module}/baseline/linux_fileshare_mount.tftpl", 
      { 
        "fileshare_path"   = "${local.fileshare_path}",
        "sa_name"         = "${local.sa_name}",
        "sa_access_key"   = "${local.sa_primary_access_key}",
        "fileshare_name"   = "${local.fileshare_name}"
      })
}

resource "local_file" "kali_cloudinit_create" {
  filename = "${path.module}/files/kali_cloud_init.cfg"
  content = templatefile("${path.module}/baseline/kali_cloud_init.tftpl", 
      { 
      #  "fileshare_path"   = "${local.fileshare_path}",
        "SA_NAME"         = "${local.sa_name}",
        "SA_ACCESS_KEY"   = "${local.sa_primary_access_key}",
        "FILESHARE_NAME"  = "${local.fileshare_name}"
        "ADMIN_PASS"      = "${var.admin_password}"
      })
}
