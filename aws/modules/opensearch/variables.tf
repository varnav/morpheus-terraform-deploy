variable "subnet_info" {
  type = map(any)
}

variable "master_user_name" {
  type = string
}

variable "master_user_password" {
  type = string
}

variable "app_vm_security_group_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

# variable "environment" {
#   type = string
# }

variable "domain_name" {
  type = string
}