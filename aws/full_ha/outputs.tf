output "app_vm_ids" {
  value = [
    for vm in module.app_vm.vm_info : vm.id
  ]
  description = "IDs of the VMs created"
}

output "app_vm_key_pair" {
  value       = module.app_vm.key_pair
  description = "PEM keypair to access EC2 instances"
  sensitive   = true
}

output "db_endpoint" {
  value       = module.db_aurora.endpoint
  description = "DNS name of the database endpoint created"
}

output "db_port" {
  value       = module.db_aurora.port
  description = "Port to use with the the database"
}

output "efs_dns_name" {
  value       = module.storage_efs.dns_name
  description = "DNS name of the EFS endpoint created"
}

output "logs_cluster_name" {
  value       = module.logs_opensearch.cluster_name
  description = "Cluster name created in Elasticsearch"
}

output "logs_endpoint" {
  value       = module.logs_opensearch.endpoint
  description = "DNS name to connect to Elasticsearch"
}

output "logs_port" {
  value       = module.logs_opensearch.port
  description = "Port used for Elasticsearch"
}

output "logs_tls_enabled" {
  value       = module.logs_opensearch.tls_enabled
  description = "Lists if TLS should be used to connect"
}

output "messaging_endpoint" {
  value       = module.messaging_amazonmq.endpoint
  description = "DNS endpoint for RabbitMQ"
}

output "messaging_console_url" {
  value       = module.messaging_amazonmq.console_url
  description = "Console URL to configure via a browser"
}

output "messaging_port" {
  value       = module.messaging_amazonmq.port
  description = "Port for RabbitMQ"
}

output "lb_arn" {
  value       = module.lb_alb.arn
  description = "ID of the load balancer created"
}

output "lb_dns_name" {
  value       = module.lb_alb.dns_name
  description = "DNS name of the LB created"
}