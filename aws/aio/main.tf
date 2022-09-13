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

resource "aws_eip" "external" {
  count    = var.internal_only == false ? 1 : 0
  instance = module.app_vm.vm_ids[0]
}