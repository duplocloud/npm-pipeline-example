
variable "svc_frontend_docker_image" {
  default = "227120241369.dkr.ecr.us-west-2.amazonaws.com/frontend:297ea03"
  type    = string
}

variable "svc_backend_docker_image" {
  default = "227120241369.dkr.ecr.us-west-2.amazonaws.com/backend:73f536c"
  type    = string
}

variable "svc_slack_docker_image" {
  default = "227120241369.dkr.ecr.us-west-2.amazonaws.com/slack:e93aeb8"
  type    = string
}

variable "svc_queue_docker_image" {
  default = "227120241369.dkr.ecr.us-west-2.amazonaws.com/backend:26eb99c"
  type    = string
}

variable "replica_count" {
  type = number
  default = 1
}

# TODO: this is kind of a hack.  I updated the apply.sh wrapper script to generate this value using TF_VAR_tenant
variable "tenant" {
  type = string
}

variable "base_domain" {
  default = "prod-apps.duplocloud.net."
  type    = string
}

variable "openai_api_key" {
  default = ""
  type    = string
  sensitive = true
}

variable "duplo_token" {
  default = ""
  type    = string
  sensitive = true
}

variable "duplo_fine_tuned_model" {
  default = "ft:gpt-3.5-turbo-0613:duplocloud:mvp-v3-5-0613:8IVbPUuu"
  type    = string
}

variable "duplo_native_context" {
  default = "Answer the question as truthfully as possible, and if you're unsure of the answer, say 'Sorry, I don't know the answer to that question.'"
  type    = string
}

variable "nonprod_slack_bot_token" {
  default = ""
  type    = string
  sensitive = true
}

variable "nonprod_slack_signing_secret" {
  default = ""
  type    = string
  sensitive = true
}

variable "prod_slack_bot_token" {
  default = ""
  type    = string
  sensitive = true
}

variable "prod_slack_signing_secret" {
  default = ""
  type    = string
  sensitive = true
}

variable "prod_containerized" {
  default = false
  type    = bool
}

variable "clickup_api_key" {
  default = ""
  type    = string
  sensitive = true
}

variable "prod_clickup_list_id" {
  default = "901301536541"
  type    = string
  sensitive = true
}

variable "nonprod_clickup_list_id" {
  default = "901301484125"
  type    = string
}

variable "slackbot_allowed_member_ids" {
  default = [
    "U05P4ALN38D", # Pranav Chakilam
    "U04MAA24JU8", # Andy Boutte
    "U0353K34QKT", # Zafar Abbas
    "U05HFPMLD4Y", # Brian Rawlins
    "U03ALJH7HNC", # Raghavan
    "U063T1RE8KX", # Cory May
    "U06423XQMSM" # Luke Baker
  ]
  type    = list
}

variable "slackbot_allowed_channel_ids" {
  default = [
    "C06AG8BPM0E" # ask-dev slack channel
  ]
  type    = list
}

variable "nonprod_pinecone_api_key" {
  default = ""
  type    = string
  sensitive = true
}

variable "prod_pinecone_api_key" {
  default = ""
  type    = string
  sensitive = true
}

variable "enable_scheduler" {
  type        = bool
  default     = false # default to false because we will only run this in prod
}

variable "scheduler_tenants" {
  description = "List of tenants the scheduler should run against"
  type        = string
  default     = ""
}

variable "shutdown_schedule" {
  default = "0 1 * * * " # 7pm central time = 1am UTC
  type    = string
}

variable "startup_schedule" {
  default = "0 13 * * *" # 7am central time = 1pm UTC
  type    = string
}

variable "queue_schedule" {
  default = "*/5 * * * *"
  type    = string
}

variable "ttl_seconds_after_finished" {
  default = "3600"
  type    = string
}

variable "concurrency_policy" {
  default = "Allow"
  type    = string
}

variable "failed_jobs_history_limit" {
  default = "10"
  type    = string
}

variable "successful_jobs_history_limit" {
  default = "10"
  type    = string
}

variable "parallelism" {
  default = "2"
  type    = string
}

variable "starting_deadline_seconds" {
  default = "60"
  type    = string
}

variable "completions" {
  default = "1"
  type    = string
}

variable "backoff_limit" {
  default = "2"
  type    = string
}

variable "active_deadline_seconds" {
  default = "300"
  type    = string
}

