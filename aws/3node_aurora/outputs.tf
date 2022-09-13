output "app_vm_ids" {
  value = [
    for vm in module.app_vm.vm_info : vm.id
  ]
}

output "app_vm_key_pair" {
  value       = module.app_vm.key_pair
  description = "PEM keypair to access EC2 instances"
  sensitive   = true
}

output "db_endpoint" {
  value = module.db_aurora.endpoint
}

output "db_port" {
  value = module.db_aurora.port
}

output "efs_dns_name" {
  value = module.storage_efs.dns_name
}

output "lb_arn" {
  value       = module.lb_alb.arn
  description = "ID of the load balancer created"
}

output "lb_dns_name" {
  value       = module.lb_alb.dns_name
  description = "DNS name of the LB created"
}