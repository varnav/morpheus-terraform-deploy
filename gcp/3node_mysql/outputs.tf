output "lb_ip_address" {
  value = module.load_balancer.lb_ip_address
}

output "instance1" {
  value = [module.vms.instance1, module.vms.instance1_ip]
}

output "instance2" {
  value = [module.vms.instance2, module.vms.instance2_ip]
}

output "instance3" {
  value = [module.vms.instance3, module.vms.instance3_ip]
}

output "nfs_mount" {
  value = module.filestore.nfs_mount
}

output "mysql" {
  value = [module.mysql.mysql_connection_name, module.mysql.mysql_ip]
}