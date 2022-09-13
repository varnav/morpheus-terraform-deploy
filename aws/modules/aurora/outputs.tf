output "endpoint" {
  value       = aws_rds_cluster.morpheus.endpoint
  description = "Database endpoint"
}

output "port" {
  value       = aws_rds_cluster.morpheus.port
  description = "Database port"
}
