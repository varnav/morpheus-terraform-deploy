variable "vpc_id" {
  type = string
}

variable "subnet_info" {
  type = map(any)
}

variable "app_vm_security_group_id" {
  type = string
}

variable "app_vm_info" {
  type = map(any)
}

variable "name" {
  type = string
}

variable "internal" {
  type = bool
}