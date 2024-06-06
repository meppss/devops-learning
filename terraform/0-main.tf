# Resource group for Service Connection environment
resource "azurerm_resource_group" "sc_rg" {
  name     = "${var.environment}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "tls_private_key" "ubuntu_ssh_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_sensitive_file" "ubuntu_key" {
    content = tls_private_key.ubuntu_ssh_key.private_key_pem
    filename = "ubuntu.pem"
    file_permission = "0600"  
}