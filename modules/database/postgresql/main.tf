resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    disk_size         = var.disk_size_gb
    disk_type         = var.disk_type

    ip_configuration {
      ipv4_enabled    = var.public_ip_enabled
      private_network = var.private_network
    }

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_disconnections"
      value = "on"
    }

    database_flags {
      name  = "log_error_verbosity"
      value = "default" # Options: "TERSE", "DEFAULT", "VERBOSE"
    }

    database_flags {
      name  = "log_statement"
      value = "ddl" # Options: "none", "ddl", "mod", "all"
    }

    database_flags {
      name  = "log_min_messages"
      value = "warning" # Minimum recommended setting
    }

    database_flags {
      name  = "log_min_error_statement"
      value = "error" # Ensures only errors or more severe issues are logged
    }

    database_flags {
      name  = "log_min_duration_statement"
      value = "-1" # Disables duration logging for all statements
    }

    database_flags {
      name  = "cloudsql.enable_pgaudit"
      value = "on" # Enables pgaudit for centralized logging
    }
  }

  deletion_protection = var.deletion_protection
}