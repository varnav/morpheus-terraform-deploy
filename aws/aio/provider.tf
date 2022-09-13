terraform {
  required_version = ">= 1.2.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.26.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Application = "Morpheus"
    }
  }
}