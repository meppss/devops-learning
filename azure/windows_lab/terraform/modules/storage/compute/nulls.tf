locals {
  win_fileshare_script_path   = "${path.module}/files/win_fileshare_mount.ps1"
  linux_fileshare_script_path = "${path.module}/files/linux_fileshare_mount.sh"
  remove_file_command = "rm $FILE"
  create_file_command = "echo '${local.fileshare_local_bash}' >> $FILE"
  # fileshare_local_bash_path = "\\\\${local.privatelink_fqdn}\\${var.fileshare_name}"
  fileshare_local_bash_path = "\\\\${local.privatelink_fqdn}\\${var.fileshare_name}"

  fileshare_local_bash = "net use S: ${local.fileshare_local_bash_path} /user:${var.sa_name} \"${var.sa_primary_access_key}\""
}

/* resource "null_resource" "win_fileshare_mount_create" {
  triggers = {
    fileshare_script_file_contents = filemd5("${local.win_fileshare_script_path}")
  }
  provisioner "local-exec" {
    command     = "[ -f $FILE ] && { ${local.remove_file_command}; ${local.create_file_command} ;} || { ${local.create_file_command} ;}"
    interpreter = ["/bin/bash", "-c"]
    # working_dir = "${path.module}"
    environment = {
      FILE = local.win_fileshare_script_path
    #  FILESHARE_PATH = local.fileshare_local_bash_path
    #  SA_NAME = var.sa_name
    #  SA_PRIMARY_ACCESS_KEY = var.sa_primary_access_key
     }
  }
} */

/* resource "null_resource" "linux_fileshare_mount_create" {
  triggers = {
    fileshare_script_file_contents = filemd5("${local.linux_fileshare_script_path}")
  }
  provisioner "local-exec" {
    command     = "[ -f $FILE ] && { ${local.remove_file_command}; ${local.create_file_command} ;} || { ${local.create_file_command} ;}"
    interpreter = ["/bin/bash", "-c"]
    # working_dir = "${path.module}"
    environment = {
      FILE = local.win_fileshare_script_path
      FILESHARE_PATH = local.fileshare_local_bash_path
      SA_NAME = var.sa_name
      SA_PRIMARY_ACCESS_KEY = var.sa_primary_access_key
     }
  }
} */

/* resource "azurerm_storage_share_file" "lab_fileshare_mount_file" {
  depends_on = [null_resource.win_fileshare_mount_create]
  name             = "win_fileshare_mount.ps1"
  storage_share_id = var.fileshare_id
  source           = "${path.module}/files/win_fileshare_mount.ps1"
  content_type     = "text/plain"
} */
