# output "dns_name" {
#   value = aws_efs_file_system.app.dns_name
# }
output "nfs_dns_name" {
  value = azurerm_private_dns_a_record.morpheus.fqdn
}

# output "nfs_ip" {
#   value = azurerm_private_endpoint.endpoint.private_dns_zone_configs
# }