variable "subnet_info" {
  type = map(any)
}

variable "app_vm_security_group_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "broker_name" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}