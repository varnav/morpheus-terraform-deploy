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
    condition     = length(var.networking_subnet_cidr_blocks) >= 3
    error_message = "networking_subnet_cidr_blocks must contain at least two CIDR blocks, one for each AZ to deploy to"
  }
}

variable "app_instance_type" {
  type        = string
  description = "Instance type that the application nodes will be deployed to.  16GB memory and 4CPUs are recommended, non-burstable."
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

variable "db_master_username" {
  type        = string
  description = "Username that will be configured on the database, must be between 1 to 32 alphanumeric characters. First character must be a letter."
  validation {
    condition     = length(var.db_master_username) >= 1 && length(var.db_master_username) <= 32
    error_message = "db_master_username must be between 1 and 32 alphanumeric characters. First character must be a letter."
  }
}

variable "db_master_password" {
  type        = string
  description = "Password at least 8 characters long and cannot contain '@', '\"', ' ', for the master user in Aurora."
  sensitive   = true
  validation {
    condition     = length(var.db_master_password) >= 8
    error_message = "db_master_password must be at least 8 characters"
  }
  validation {
    condition     = length(regexall("@", var.db_master_password)) == 0 && length(regexall("\"", var.db_master_password)) == 0 && length(regexall(" ", var.db_master_password)) == 0 && length(regexall("'", var.db_master_password)) == 0
    error_message = "db_master_password cannot contain the following characters: '@', '\"', ' ', or ''' "
  }
}

variable "db_cluster_id" {
  type        = string
  description = "Name for the RDS cluster to make it more user friendly.  This should be unique in the environment, if additional deployments will be made.  Ex: morpheus-dev"
}

variable "lb_name" {
  type        = string
  description = "Name for the load balancer.  This should be unique in the environment, if additional deployments will be made.  Can only contain alphaumeric and hyphens (-). Ex: morpheus-dev"
}

variable "internal_only" {
  type        = bool
  description = "Will the load balancer be internal facing only, or external facing?"
}