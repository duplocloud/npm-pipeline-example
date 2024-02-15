terraform {
  required_version = ">= 1.5.5"
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = "~> 0.10.5"
    }
  }
}
provider "duplocloud" {

}
