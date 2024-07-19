output "tenant_name" {
  value       = duplocloud_tenant.tenant.account_name
  description = "The tenant name"
}
output "tenant_id" {
  value       = duplocloud_tenant.tenant.tenant_id
  description = "The tenant ID"
}

output "infra_name" {
  value       = data.duplocloud_infrastructure.infra.infra_name
  description = "The duplo infra name."
}
output "vpc_id" {
  value       = data.duplocloud_infrastructure.infra.vpc_id
  description = "The VPC or VNet ID."
}
output "region" {
  value       = local.region
  description = "The AWS region the Tenant is located in"
}

