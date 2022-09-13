variable "master_username" {
  type        = string
  description = "Username for the DB master user"
}

variable "master_password" {
  type        = string
  description = "Password for the DB master user"
}

variable "subnet_info" {
  type        = map(any)
  description = "List of at least two subnet IDs required for the database subnet group"
}

variable "cluster_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "app_vm_security_group_id" {
  type = string
}