
# we have two slack bots, prod and non prod.  In Duplo, all non prod environments (dev, demo, marketting, etc),
# will use the nonprod slack bot
resource "duplocloud_k8_secret" "slack" {
  tenant_id   = local.tenant_id
  secret_name = "slack"
  secret_type = "Opaque"
  secret_data = jsonencode({
    "SLACK_BOT_TOKEN" : var.tenant == "ask-prod" ? var.prod_slack_bot_token : var.nonprod_slack_bot_token
    "SLACK_SIGNING_SECRET" : var.tenant == "ask-prod" ? var.prod_slack_signing_secret : var.nonprod_slack_signing_secret
    }
  )
}

resource "duplocloud_k8_secret" "openai" {
  tenant_id   = local.tenant_id
  secret_name = "openai"
  secret_type = "Opaque"
  secret_data = jsonencode({
    "OPENAI_API_KEY" : var.openai_api_key
    }
  )
}

resource "duplocloud_k8_secret" "clickup" {
  tenant_id   = local.tenant_id
  secret_name = "clickup"
  secret_type = "Opaque"
  secret_data = jsonencode({
    "CLICKUP_TOKEN" : var.clickup_api_key
    }
  )
}

resource "duplocloud_k8_secret" "pinecone" {
  tenant_id   = local.tenant_id
  secret_name = "pinecone"
  secret_type = "Opaque"
  secret_data = jsonencode({
    "PINECONE_API_KEY" : var.tenant == "ask-prod" ? var.prod_pinecone_api_key : var.nonprod_pinecone_api_key
    }
  )
}
