output "asg_id" {
  value = azurerm_application_security_group.asg.id
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}