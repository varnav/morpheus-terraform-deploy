output "arn" {
  value       = aws_lb.load_balancer.arn
  description = "ID of the load balancer created"
}

output "dns_name" {
  value       = aws_lb.load_balancer.dns_name
  description = "DNS name of the LB created"
}