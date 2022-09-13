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

module "app_cluster_sg_rules" {
  source                   = "../modules/app_cluster_sg_rules"
  app_vm_security_group_id = module.app_vm.security_group_id
  services_ingress_ports = [
    "9200",  # elasticsearch API access
    "9300",  # elasticsearch cluster communication
    "4369",  # RabbitMQ empd peer discovery
    "5671",  # RabbitMQ AMQP client access (SSL)
    "5672",  # RabbitMQ AMQP client access
    "15672", # RabbitMQ API access and management UI
    "25672", # RabbitMQ inter-node communication
    "61613"  # RabbitMQ STOMP clients
  ]
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


module "lb_alb" {
  source                   = "../modules/alb"
  vpc_id                   = module.networking.vpc_id
  subnet_info              = module.networking.subnet_info
  app_vm_security_group_id = module.app_vm.security_group_id
  app_vm_info              = module.app_vm.vm_info
  name                     = var.lb_name
  internal                 = var.internal_only
}