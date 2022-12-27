resource "azurerm_application_security_group" "asg" {
  name                = "morpheus_${var.role_type}_node"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = "morpheus-${var.role_type}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "db_mysql" {
  name                        = "AllowMySqlFromAppNodes"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  # source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  source_application_security_group_ids = [
    var.app_asg_id
  ]
}

resource "azurerm_network_security_rule" "db_cluster" {
  name                        = "AllowDbClusterComms"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges      = [
    "4444",
    "4567",
    "4568"
  ]
  # source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  source_application_security_group_ids = [
    azurerm_application_security_group.asg.id
  ]
}