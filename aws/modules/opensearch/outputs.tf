output "cluster_name" {
  value       = "${data.aws_caller_identity.current.account_id}:${var.domain_name}"
  description = "Cluster name created in Elasticsearch"
}

output "endpoint" {
  value       = aws_elasticsearch_domain.elastic.endpoint
  description = "DNS name to connect to Elasticsearch"
}

output "port" {
  value       = 443
  description = "Port used for Elasticsearch"
}

output "tls_enabled" {
  value       = aws_elasticsearch_domain.elastic.domain_endpoint_options[0].enforce_https
  description = "Lists if TLS should be used to connect"
}