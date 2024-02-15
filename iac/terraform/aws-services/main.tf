data "aws_caller_identity" "current" {
}

data "duplocloud_aws_account" "aws" { 
  tenant_id = local.tenant_name
}

data "duplocloud_tenant" "tenant" {
  name = local.tenant_name
}


data "duplocloud_tenant_aws_region" "current" {
  tenant_id = local.tenant_id
}

locals {
  tfstate_bucket = "duplo-tfstate-${data.aws_caller_identity.current.account_id}"
  region = data.duplocloud_tenant_aws_region.current.aws_region
  tenant_id      = data.duplocloud_tenant.tenant.id 
  cert_arn       = data.terraform_remote_state.tenant.outputs["cert_arn"]
  tenant_name    = terraform.workspace
  infra_name     = data.terraform_remote_state.tenant.outputs["infra_name"]
}

data "duplocloud_tenant_aws_kms_key" "tenant_kms" {
  tenant_id = local.tenant_id
}

data "duplocloud_plan" "plan" {
  plan_id = local.infra_name
}

data "terraform_remote_state" "tenant" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket               = local.tfstate_bucket
    workspace_key_prefix = "admin:"
    key                  = "tenant"
    region               = "us-west-2"
  }
}


