terraform {
   required_version = ">= 0.14.5"

   required_providers {
     google = ">= 3.0.0"
   }
}

provider "google" {
  #credentials = var.gcp_auth
  region      = var.region
  project     = var.project
 }