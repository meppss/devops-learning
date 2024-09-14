output "sa_name" {
  value = azurerm_storage_account.lab_sa.name
}
output "sa_id" {
  value = azurerm_storage_account.lab_sa.id
}
output "fileshare_id" {
  value = azurerm_storage_share.lab_sa_share.id
}
output "fileshare_name" {
  value = azurerm_storage_share.lab_sa_share.name
}
output "sa_primary_access_key" {
  value = azurerm_storage_account.lab_sa.primary_access_key
}
output "kali_cloudinit_filename" {
  value = local_file.kali_cloudinit_create.filename
}
