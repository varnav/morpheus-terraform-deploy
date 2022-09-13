variable "subnet_info" {
  type = map(any)
}

variable "instance_type" {
  type        = string
  description = "Instance type to use"
}

variable "vpc_id" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "volume_type" {
  type = string
}

variable "key_name" {
  type        = string
  description = "Key pair name to use"
}

variable "os_flavor" {
  type = string
}