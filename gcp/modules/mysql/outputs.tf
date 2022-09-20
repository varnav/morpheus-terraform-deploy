output "mysql_ip" {
  value = google_sql_database_instance.instance.private_ip_address
}

output "mysql_connection_name" {
  value = google_sql_database_instance.instance.connection_name
}