terraform {
  required_version = ">= 1.2.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.36.0"
    }
  }
}

provider "azurerm" {
  features {
    # managed_disk {
    #   expand_without_downtime = true
    # }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = true
    }
  }
}

provider "tls" {

}