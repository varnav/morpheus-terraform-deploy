output "db_subnet_id" {
  value = azurerm_subnet.db.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "ag_frontend_subnet_id" {
  value = azurerm_subnet.ag_frontend.id
}

output "ag_backend_subnet_id" {
  value = azurerm_subnet.ag_backend.id
}

output "nfs_subnet_id" {
  value = azurerm_subnet.nfs.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
}

output "ag_backend_subnet_name" {
  value = azurerm_subnet.ag_backend.name
}