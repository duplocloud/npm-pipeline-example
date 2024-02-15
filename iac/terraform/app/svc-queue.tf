
# https://www.middlewareinventory.com/blog/kubernetes-cronjob-best-practices/

resource "duplocloud_k8s_cron_job" "queue" {
  tenant_id = local.tenant_id
  metadata {
    name = "queue-processor"
  }
  spec {
    job_template {
      spec {
        parallelism = var.parallelism
        completions = var.completions
        backoff_limit = var.backoff_limit
        active_deadline_seconds = var.active_deadline_seconds
        ttl_seconds_after_finished = var.ttl_seconds_after_finished
        template {
          spec {
            restart_policy = "Never"
            container {
              name              = "scheduler"
              image             = var.svc_queue_docker_image
              image_pull_policy = "Always"
              
              env {
                name  = "CONTAINER_ROLE"
                value = "queue"
              }
              env {
                name  = "DUPLO"
                value = "true"
              }

              env {
                name  = "SQS_QUEUE_URL"
                value = local.sqs_queue_url
              }
              env {
                name  = "AWS_REGION"
                value = local.region
              }
              env {
                name  = "SQS_QUEUE_FULLNAME"
                value = local.sqs_queue_fullname
              }
              env {
                name  = "SQS_QUEUE_ARN"
                value = local.sqs_queue_arn
              }

              env {
                name  = "S3_BUCKET"
                value = data.terraform_remote_state.aws-services.outputs["s3_search_fullname"]
              }
              env {
                name  = "PINECONE_API_KEY"
                value_from {
                    secret_key_ref {
                        key = "PINECONE_API_KEY"
                        name = "pinecone"
                    }
                }
              }
              env {
                name  = "OPENAI_API_KEY"
                value_from {
                    secret_key_ref {
                        key = "OPENAI_API_KEY"
                        name = "openai"
                    }
                }
              }
              env {
                name  = "PINECONE_ENV"
                value = terraform.workspace == "ask-prod" ? "us-central1-gcp" : "gcp-starter"
              }
              env {
                name  = "PINECONE_INDEX_NAME"
                value = terraform.workspace == "ask-prod" ? "askduplocloud-prod" : "askduplocloud-dev"
              }



            }
          }
        }
      }
    }
    schedule                      = var.queue_schedule
    concurrency_policy            = var.concurrency_policy
    failed_jobs_history_limit     = var.failed_jobs_history_limit
    successful_jobs_history_limit = var.successful_jobs_history_limit
    starting_deadline_seconds = var.starting_deadline_seconds
  }
  lifecycle {
    ignore_changes = [
      spec[0].job_template[0].spec[0].template[0].spec[0].container[0].image
    ]
  }
}
