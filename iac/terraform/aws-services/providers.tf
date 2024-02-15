terraform {
  required_version = ">= 1.5.5"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = "~> 0.10.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.2"
    }
  }
}
provider "duplocloud" {

}
provider "aws" {
  region = data.duplocloud_tenant_aws_region.current.aws_region
}

provider "random" {}
