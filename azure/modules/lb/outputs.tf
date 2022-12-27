# output "arn" {
#   value       = aws_lb.load_balancer.arn
#   description = "ID of the load balancer created"
# }

# output "dns_name" {
#   value       = aws_lb.load_balancer.dns_name
#   description = "DNS name of the LB created"
# }

output "server_certificate_crt" {
    value = tls_locally_signed_cert.server.cert_pem
}

output "server_certificate_key" {
    value = tls_private_key.server.private_key_pem
}

output "public_ip" {
    value = azurerm_public_ip.lb.ip_address
}

output "lb_info" {
    value = azurerm_application_gateway.network
}

output "server_cert_cn" {
    value = local.server_cert_cn
}

output "internal_subnet" {
    value = var.subnet_id
}