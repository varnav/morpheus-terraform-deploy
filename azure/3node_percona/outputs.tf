output "server_certificate_crt" {
  value = module.lb.server_certificate_crt
}

output "server_certificate_key" {
  value = module.lb.server_certificate_key
  sensitive   = true
}

output "app_vm_info" {
  value = [
    for vm in module.app_vm.vm_info : {
        name = vm.name
        private_ip = vm.private_ip_address
        public_ip = vm.public_ip_address
    }
  ]
}

output "db_vm_info" {
  value = [
    for vm in module.db_vm.vm_info : {
        name = vm.name
        private_ip = vm.private_ip_address
        public_ip = vm.public_ip_address
    }
  ]
}

output "vm_key_pair" {
  value       = tls_private_key.rsa.private_key_pem
  description = "PEM keypair to access Azure instances"
  sensitive   = true
}

output "nfs_dns_name" {
  value = trim(module.nfs.nfs_dns_name,".")
}

# output "db_endpoint" {
#   value = module.db_aurora.endpoint
# }

output "db_endpoint" {
  value = "{${join("",[
        for zone in local.zones : "${module.app_vm.vm_info[zone].private_ip_address} => 3606${length(local.zones)-1 != index(local.zones,zone) ? "," : ""}"
    ])}}"
}

output "lb_info" {
    value = {
        public_ip = module.lb.public_ip
        name = module.lb.lb_info.name
        server_cert_cn = module.lb.server_cert_cn
        backend_subnet_name = module.networking.ag_backend_subnet_name
    }
}