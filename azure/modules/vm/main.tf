resource "azurerm_public_ip" "ip" {
  for_each            = toset(var.zones)
  name                = "morpheus-${var.role_type}${each.value}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  zones               = var.zones
  sku                 = "Standard"
}

resource "azurerm_network_interface" "int" {
  for_each            = toset(var.zones)
  name                = "morpheus-${var.role_type}${each.value}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = lookup(azurerm_public_ip.ip["${each.value}"], "id")
  }
}

resource "azurerm_network_interface_application_security_group_association" "asg_assoc" {
  for_each                      = azurerm_network_interface.int
  network_interface_id          = each.value.id
  application_security_group_id = var.application_security_group_id
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  for_each                  = azurerm_network_interface.int
  network_interface_id      = each.value.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = toset(var.zones)
  name                = "morpheus-${var.role_type}${each.value}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  network_interface_ids = [
    lookup(azurerm_network_interface.int["${each.value}"], "id")
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal" # 0001-com-ubuntu-server-jammy == 22.04
    sku       = "20_04-lts-gen2"               # 22_04-lts-gen2
    version   = "latest"
  }
  zone = each.value
}