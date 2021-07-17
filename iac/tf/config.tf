
terraform {
  backend "remote" {
    organization = "avalier"
    workspaces {
      name = "avalier-demo"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

# Get outputs from spoke/vpc workspace #

data "terraform_remote_state" "spoke" {
  backend = "remote"
  config = {
    organization = "avalier"
    workspaces = {
      name = "avalier-iac-aws"
    }
  }
}

# Get route53 zone #

data "aws_route53_zone" "zone" {
  name = var.domain_name
}

# Locals (for convenience) #

locals {
  vpc_id              = data.terraform_remote_state.spoke.outputs.vpc_id
  public_subnets      = data.terraform_remote_state.spoke.outputs.vpc_public_subnets
  private_subnets     = data.terraform_remote_state.spoke.outputs.vpc_private_subnets
  zone_id             = data.aws_route53_zone.zone.zone_id
  zone_name           = data.aws_route53_zone.zone.name
  is_highly_available = true
  is_sensitive        = false
  is_external_facing  = false
}

