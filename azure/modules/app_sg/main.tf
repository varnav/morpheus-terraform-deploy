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

resource "azurerm_network_security_rule" "app_clients" {
  name                        = "AllowWebFromClients"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  source_port_range           = "*"
    destination_port_ranges      = [
    "80",
    "443"
  ]
    destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "app_cluster_comms" {
  name                        = "AllowAppClusterComms"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges      = [
    "4369",  # Rabbit epmd
    "25672", # Rabbit inter-node/CLI comms
    "9300"   # Elastic
  ]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  source_application_security_group_ids = [
    azurerm_application_security_group.asg.id
  ]
}

resource "azurerm_network_security_rule" "app_cluster_services" {
  name                        = "AllowAppClusterServices"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges      = [
    "5671", # Rabbit TLS
    "5672", # Rabbit w/o TLS
    "9200"  # Elastic
  ]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  source_application_security_group_ids = [
    azurerm_application_security_group.asg.id
  ]
}