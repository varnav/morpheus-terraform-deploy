output "nfs_dns_name" {
  value = azurerm_private_dns_a_record.morpheus.fqdn
}