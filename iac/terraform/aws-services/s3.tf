
resource "duplocloud_s3_bucket" "search" {
  tenant_id           = local.tenant_id
  name                = "search"
  allow_public_access = var.s3_search_allow_public_access
  enable_access_logs  = var.s3_search_enable_access_logs
  enable_versioning   = var.s3_search_enable_versioning
  managed_policies = ["ssl"]
  default_encryption {
    method = "Sse"
  }
}
