resource "google_sql_database" "main" {
  name     = "${var.naming_prefix}-mysql"
  instance = google_sql_database_instance.instance.name
  charset = "utf8mb4"
  collation = "utf8mb4_general_ci"
}

resource "google_sql_database_instance" "instance" {
name             = "${var.naming_prefix}-db"
database_version = "MYSQL_8_0"
deletion_protection=false
settings {
tier             = "db-f1-micro"
ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }
}
}

resource "google_sql_user" "users" {
name = var.mysql_username
instance = "${google_sql_database_instance.instance.name}"
host = "%"
password = var.mysql_password
}
