resource "google_sql_database" "main" {
  name     = "${var.naming_prefix}-mysql"
  instance = google_sql_database_instance.instance.name
  charset = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_database_instance" "instance" {
name             = "${var.naming_prefix}-db"
database_version = "MYSQL_5_7"
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