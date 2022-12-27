resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account" "nfs" {
  name                            = "${var.storage_account_name_prefix}${random_string.random.result}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Premium"
  account_replication_type        = "ZRS"
  account_kind                    = "FileStorage"
  allow_nested_items_to_be_public = false
  # public_network_access_enabled must be true if using Terraform from outside the vNet
  # If public_network_access_enabled is not true, an authorization error will be encountered
  public_network_access_enabled = true
  # enable_https_traffic_only must be false when using NFS file shares ('Secure transfer required' in the portal)
  enable_https_traffic_only = false
  # shared_access_key_enabled must be true when using NFS file shares ('Allow storage account key access' in the portal)
  shared_access_key_enabled = true
}

resource "azurerm_storage_share" "nfs" {
  name                 = "nfsshare"
  storage_account_name = azurerm_storage_account.nfs.name
  quota                = 200
  enabled_protocol     = "NFS"
}

resource "azurerm_private_dns_zone" "dns" {
  name                = "morpheus.file.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_endpoint" "endpoint" {
  name                = "morpheus-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.nfs_subnet_id
  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.dns.id
    ]
  }
  private_service_connection {
    name                 = "morpheus-privateservice"
    is_manual_connection = false
    subresource_names = [
      "file"
    ]
    private_connection_resource_id = azurerm_storage_account.nfs.id
  }
}

resource "azurerm_private_dns_a_record" "morpheus" {
  name                = azurerm_storage_account.nfs.name
  zone_name           = azurerm_private_dns_zone.dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 10
  records = [
    azurerm_private_endpoint.endpoint.private_service_connection[0].private_ip_address
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "morpheus" {
  name                  = "morpheus-virtual-network-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = var.virtual_network_id
}