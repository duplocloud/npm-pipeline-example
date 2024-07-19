locals {
  plan_id     = var.infra_name
  tenant_name = terraform.workspace
  region = data.duplocloud_infrastructure.infra.region
}

data "duplocloud_infrastructure" "infra" {
  infra_name = var.infra_name
}

resource "duplocloud_tenant" "tenant" {
  account_name   = local.tenant_name
  plan_id        = local.plan_id
  allow_deletion = true
}

resource "duplocloud_tenant_config" "tenant-config" {
  tenant_id = duplocloud_tenant.tenant.tenant_id
  setting {
    key   = "delete_protection"
    value = "true"
  }
}
