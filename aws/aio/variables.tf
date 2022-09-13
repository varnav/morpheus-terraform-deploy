variable "region" {
  type        = string
  description = "AWS region"
}

variable "networking_vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC that will be created.  This can be a duplicate of any already in the environment.  The subnets that will be entered for networking_subnet_cidr_blocks should match this CIDR"
}

variable "networking_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of subnets that should be deployed to.  These will be created, along with the VPC.  The CIDRs should be contained in the CIDR entered for networking_vpc_cidr_block"
  validation {
    condition     = length(var.networking_subnet_cidr_blocks) == 1
    error_message = "networking_subnet_cidr_blocks must contain at least two CIDR blocks, one for each AZ to deploy to"
  }
}

variable "app_instance_type" {
  type        = string
  description = "Instance type that the application nodes will be deployed to"
}

variable "app_volume_size" {
  type        = number
  description = "Size of the root volume in GB"
}

variable "app_volume_type" {
  type        = string
  description = "Type of underlying disk:  gp2, gp3, etc."
}

variable "app_key_name" {
  type        = string
  description = "Key pair name to create and use for authentication"
}

variable "app_os_flavor" {
  type        = string
  description = "Deploys the latest version of the OS.  Must be one of the following values:  amazonlinux2, rhel, ubuntu"
  validation {
    condition     = var.app_os_flavor == "amazonlinux2" || var.app_os_flavor == "rhel" || var.app_os_flavor == "ubuntu"
    error_message = "app_os_flavor must be a supported value"
  }
}

variable "internal_only" {
  type        = bool
  description = "Will the load balancer be internal facing only, or external facing?"
}