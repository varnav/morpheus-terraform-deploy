output "vm_ids" {
  value = values(aws_instance.app)[*].id
}

output "vm_info" {
  value = aws_instance.app
}

output "security_group_id" {
  value = aws_security_group.app.id
}

output "key_pair" {
  value     = tls_private_key.rsa.private_key_pem
  sensitive = true
}
