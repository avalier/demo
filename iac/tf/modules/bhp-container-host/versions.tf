terraform {
  required_version = ">= 0.12.21"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0"
    }
  }
}