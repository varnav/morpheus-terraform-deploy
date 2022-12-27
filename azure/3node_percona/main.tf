locals {
  zones = [
    "1",
    "2",
    "3"
  ]
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
}

module "networking" {
  source              = "../modules/networking"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "app_sg" {
  source              = "../modules/app_sg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  role_type           = "app"
}

module "db_sg" {
  source              = "../modules/db_sg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  role_type           = "db"
  app_asg_id          = module.app_sg.asg_id
}

module "app_vm" {
  source                        = "../modules/vm"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  role_type                     = "app"
  subnet_id                     = module.networking.db_subnet_id
  size                          = "Standard_D4s_v3"
  public_key                    = tls_private_key.rsa.public_key_openssh
  application_security_group_id = module.app_sg.asg_id
  network_security_group_id     = module.app_sg.nsg_id
  admin_username                = var.vm_admin_username
  zones                         = local.zones
  disk_size_gb                  = var.app_volume_size
}

module "db_vm" {
  source                        = "../modules/vm"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  role_type                     = "db"
  subnet_id                     = module.networking.app_subnet_id
  size                          = "Standard_D2s_v3"
  public_key                    = tls_private_key.rsa.public_key_openssh
  application_security_group_id = module.db_sg.asg_id
  network_security_group_id     = module.db_sg.nsg_id
  admin_username                = var.vm_admin_username
  zones                         = local.zones
  disk_size_gb                  = var.app_volume_size
}

module "lb" {
  source                 = "../modules/lb"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  subnet_id              = module.networking.ag_backend_subnet_id
  app_network_interfaces = module.app_vm.network_interfaces
  zones                  = local.zones
}

module "nfs" {
  source                      = "../modules/nfs"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  nfs_subnet_id               = module.networking.nfs_subnet_id
  virtual_network_id          = module.networking.virtual_network_id
  storage_account_name_prefix = var.storage_account_name_prefix
}