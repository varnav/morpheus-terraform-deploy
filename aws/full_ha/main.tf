module "networking" {
  source             = "../modules/networking"
  vpc_cidr_block     = var.networking_vpc_cidr_block
  subnet_cidr_blocks = var.networking_subnet_cidr_blocks
}

module "app_vm" {
  source        = "../modules/vm"
  subnet_info   = module.networking.subnet_info
  instance_type = var.app_instance_type
  vpc_id        = module.networking.vpc_id
  volume_size   = var.app_volume_size
  volume_type   = var.app_volume_type
  key_name      = var.app_key_name
  os_flavor     = var.app_os_flavor
}

module "storage_efs" {
  source                   = "../modules/efs"
  app_vm_security_group_id = module.app_vm.security_group_id
  subnet_info              = module.networking.subnet_info
  vpc_id                   = module.networking.vpc_id
}

module "db_aurora" {
  source                   = "../modules/aurora"
  vpc_id                   = module.networking.vpc_id
  app_vm_security_group_id = module.app_vm.security_group_id
  master_username          = var.db_master_username
  master_password          = var.db_master_password
  subnet_info              = module.networking.subnet_info
  cluster_id               = var.db_cluster_id
}

module "logs_opensearch" {
  source                   = "../modules/opensearch"
  vpc_id                   = module.networking.vpc_id
  app_vm_security_group_id = module.app_vm.security_group_id
  master_user_name         = var.logs_master_user_name
  master_user_password     = var.logs_master_user_password
  subnet_info              = module.networking.subnet_info
  domain_name              = var.logs_domain_name
}

module "messaging_amazonmq" {
  source                   = "../modules/amazonmq"
  vpc_id                   = module.networking.vpc_id
  app_vm_security_group_id = module.app_vm.security_group_id
  subnet_info              = module.networking.subnet_info
  broker_name              = var.messaging_broker_name
  engine_version           = var.messaging_engine_version
  username                 = var.messaging_username
  password                 = var.messaging_password
}

module "lb_alb" {
  source                   = "../modules/alb"
  vpc_id                   = module.networking.vpc_id
  subnet_info              = module.networking.subnet_info
  app_vm_security_group_id = module.app_vm.security_group_id
  app_vm_info              = module.app_vm.vm_info
  name                     = var.lb_name
  internal                 = var.internal_only
}