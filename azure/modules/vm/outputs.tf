output "network_interfaces" {
  value = azurerm_network_interface.int
}

output "vm_info" {
  value = azurerm_linux_virtual_machine.vm
}
