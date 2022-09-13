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

output "app_vm_eip_dns" {
  value       = length(aws_eip.external) > 0 ? aws_eip.external[0].public_dns : null
  description = "Public DNS address for the EIP created"
}