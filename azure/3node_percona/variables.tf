variable "region" {
  type        = string
  description = "Azure region"
}

variable "vm_admin_username" {
  type        = string
  description = "Username used to login to the virtual machines"
}

variable "app_volume_size" {
  type = string
}

variable "db_volume_size" {
  type = string
}

variable "resource_group_name" {
  type = string
}

# storage_account_name must be unique globally
variable "storage_account_name_prefix" {
  type = string
}