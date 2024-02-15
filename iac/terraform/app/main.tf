data "aws_caller_identity" "current" {
}

data "duplocloud_tenant_aws_region" "current" {
  tenant_id = local.tenant_id
}

locals {
  tfstate_bucket = "duplo-tfstate-${data.aws_caller_identity.current.account_id}"
  region         = data.duplocloud_tenant_aws_region.current.aws_region
  tenant_id      = data.terraform_remote_state.tenant.outputs["tenant_id"]
  cert_arn       = data.terraform_remote_state.tenant.outputs["cert_arn"]
  tenant_name    = data.terraform_remote_state.tenant.outputs["tenant_name"]
  sqs_queue_url = data.terraform_remote_state.aws-services.outputs["sqs_queue_url"]
  sqs_queue_fullname = data.terraform_remote_state.aws-services.outputs["sqs_queue_fullname"]
  sqs_queue_arn = data.terraform_remote_state.aws-services.outputs["sqs_queue_arn"]
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

data "terraform_remote_state" "aws-services" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket               = local.tfstate_bucket
    workspace_key_prefix = "tenant:"
    key                  = "aws-services"
    region               = "us-west-2"
  }
}

data "duplocloud_tenant" "tenant" {
  name = var.tenant
}

data "duplocloud_tenant_aws_credentials" "test" { tenant_id = data.duplocloud_tenant.tenant.id }

data "duplocloud_admin_aws_credentials" "this" {}

provider "aws" {
  access_key = data.duplocloud_admin_aws_credentials.this.access_key_id
  secret_key = data.duplocloud_admin_aws_credentials.this.secret_access_key
  token      = data.duplocloud_admin_aws_credentials.this.session_token
  region     = "us-west-2"
}
