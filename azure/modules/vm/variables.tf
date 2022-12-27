variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}

variable "role_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "size" {
  type = string
}

variable "public_key" {
  type = string
}

variable "application_security_group_id" {
  type = string
}

variable "network_security_group_id" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "zones" {
  type = list(any)
}

variable "disk_size_gb" {
  type = string
}
