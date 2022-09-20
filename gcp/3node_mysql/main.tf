module "networking" {
  source             = "../modules/networking"
  naming_prefix     = var.naming_prefix
  subnet_cidr_block = var.networking_subnet_cidr_block
  create_router = var.create_router
}

module "load_balancer" {
  source                   = "../modules/load_balancer"
  naming_prefix = var.naming_prefix
  instance_grp1 = module.vms.morphgrp1
  instance_grp2 = module.vms.morphgrp2
  instance_grp3 = module.vms.morphgrp3
}

module "vms" {
  source        = "../modules/vms"
  naming_prefix = var.naming_prefix
  subnet_name = module.networking.subnet
  disk_size = var.disk_size
  os_flavor = var.os_flavor
  machine_type = var.machine_type
}

module "mysql" {
  source        = "../modules/mysql"
  naming_prefix = var.naming_prefix
  vpc_id = module.networking.vpcid
  mysql_username = var.mysql_username
  mysql_password = var.mysql_password
  depends_on = [module.networking]
}

module "filestore" {
  source        = "../modules/filestore"
  naming_prefix = var.naming_prefix
  vpcname = module.networking.vpcname
  region = var.region
  zones = module.vms.zones
  depends_on = [module.networking]

}