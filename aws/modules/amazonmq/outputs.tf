output "endpoint" {
  value       = substr(split(":", aws_mq_broker.amazonmq.instances.0.endpoints.0)[1], 2, -1)
  description = "DNS endpoint for RabbitMQ"
}

output "port" {
  value       = split(":", aws_mq_broker.amazonmq.instances.0.endpoints.0)[2]
  description = "Port for RabbitMQ"
}

output "console_url" {
  value       = aws_mq_broker.amazonmq.instances.0.console_url
  description = "Console URL to configure via a browser"
}