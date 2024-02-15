resource "duplocloud_duplo_service" "slack" {
  tenant_id                            = local.tenant_id
  name                                 = "slack"
  replicas                             = var.replica_count
  lb_synced_deployment                 = false
  cloud_creds_from_k8s_service_account = false
  is_daemonset                         = false
  is_unique_k8s_node_required = true
  agent_platform                       = 7
  cloud                                = 0
  other_docker_config = jsonencode({
    "Env" : [
      {
        "Name" : "KB_SAVE_BUCKET",
        "Value" : data.terraform_remote_state.aws-services.outputs["s3_search_fullname"]
      },
      {
        "Name" : "DUPLO",
        "Value" : true
      },
      {
        "Name" : "ASK_DUPLO_URL",
        "Value" : "http://backend:5000/get_answer"
      },
      {
        "name" : "OPENAI_API_KEY",
        "valueFrom" : {
          "secretKeyRef" : {
            "key" : "OPENAI_API_KEY",
            "name" : "openai"
          }
        }
      },
      {
        "name" : "SLACK_BOT_TOKEN",
        "valueFrom" : {
          "secretKeyRef" : {
            "key" : "SLACK_BOT_TOKEN",
            "name" : "slack"
          }
        }
      },
      {
        "name" : "SLACK_SIGNING_SECRET",
        "valueFrom" : {
          "secretKeyRef" : {
            "key" : "SLACK_SIGNING_SECRET",
            "name" : "slack"
          }
        }
      },
      {
        "name" : "CLICKUP_TOKEN",
        "valueFrom" : {
          "secretKeyRef" : {
            "key" : "CLICKUP_TOKEN",
            "name" : "clickup"
          }
        }
      },
      {
        "Name" : "CLICKUP_LIST_ID",
        "Value" : terraform.workspace == "ask-prod" ? var.prod_clickup_list_id : var.nonprod_clickup_list_id
      },
      {
        "Name" : "SLACK_ALLOWED_MEMBER_IDS",
        "Value" : "${join(", ", var.slackbot_allowed_member_ids)}"
      },
      {
        "Name" : "SLACK_ALLOWED_CHANNEL_IDS", # in ask-dev pass in allowed channel IDs, ask-prod is set to "" which allows it to be used in all channels
        "Value" : "${join(", ", terraform.workspace == "ask-dev" ? var.slackbot_allowed_channel_ids : [""])}"
      }
      
    ]
    }
  )  
  docker_image = var.svc_slack_docker_image

  lifecycle {
    ignore_changes = [
      docker_image
    ]
  }
}

resource "duplocloud_duplo_service_lbconfigs" "slack_config" {
  tenant_id                   = duplocloud_duplo_service.slack.tenant_id
  replication_controller_name = duplocloud_duplo_service.slack.name
  lbconfigs {
    lb_type          = 7
    is_native        = false
    is_internal      = false
    port             = 3000
    external_port    = 3000
    protocol         = "http"
    health_check_url = "/health"
  }
}
