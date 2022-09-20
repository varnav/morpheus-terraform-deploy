#variable "gcp_auth"{}

variable "region" {
}

variable "project"{
  type = string
}

variable "naming_prefix" {
  type        = string
  description = "This Name prefix will be used to create resources such as instances, instance groups, VPC, Subnet, etc "
}

variable "networking_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the Subnet that will be created.  This can be a duplicate of any already in the environment."
}
variable "mysql_username" {
  type        = string
  description = "Username for the DB admin user"
}

variable "mysql_password" {
  type        = string
  description = "Password for the DB admin user"
}

variable "create_router" {
  type        = bool
}

variable "disk_size" {
  type        = string
}

variable "os_flavor" {
  type        = string
  description = "Deploys the latest version of the OS.  Must be one of the following values:  debian, rhel, ubuntu"
  validation {
    condition     = var.os_flavor == "debian" || var.os_flavor == "rhel" || var.os_flavor == "ubuntu"
    error_message = "os_flavor must be a supported value"
  }
}
variable "machine_type"{
  type = string
}
