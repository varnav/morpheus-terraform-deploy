variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "app_network_interfaces" {
}

variable "zones" {
  type        = list
}
