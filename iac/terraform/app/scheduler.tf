
resource "duplocloud_k8_secret" "duplo_token" {
  count       = var.enable_scheduler ? 1 : 0
  tenant_id   = local.tenant_id
  secret_name = "duplo-token"
  secret_type = "Opaque"
  secret_data = jsonencode({
    "DUPLO_TOKEN" : var.duplo_token
    }
  )
}

resource "duplocloud_k8s_cron_job" "stop" {
  count     = var.enable_scheduler ? 1 : 0
  tenant_id = local.tenant_id
  metadata {
    name = "stop"
  }
  spec {
    job_template {
      spec {
        ttl_seconds_after_finished = "172800"
        template {
          spec {
            restart_policy = "Never"
            container {
              name              = "scheduler"
              image             = "227120241369.dkr.ecr.us-west-2.amazonaws.com/scheduler:latest"
              image_pull_policy = "Always"
              command           = ["python", "./main.py"]
              env {
                name  = "duplo_action"
                value = "stop"
              }

              env {
                name  = "duplo_host"
                value = "https://prod.duplocloud.net"
              }
              env {
                name  = "tenant_names"
                value = var.scheduler_tenants
              }
              env {
                name = "duplo_token"
                value_from {
                  secret_key_ref {
                    key  = "DUPLO_TOKEN"
                    name = "duplo-token"
                  }
                }
              }
            }
          }
        }
      }
    }
    schedule                      = var.shutdown_schedule
    concurrency_policy            = "Forbid"
    failed_jobs_history_limit     = 10
    successful_jobs_history_limit = 10

  }
}

resource "duplocloud_k8s_cron_job" "start" {
  count     = var.enable_scheduler ? 1 : 0
  tenant_id = local.tenant_id
  metadata {
    name = "start"
  }
  spec {
    job_template {
      spec {
        ttl_seconds_after_finished = "172800"
        template {
          spec {
            restart_policy = "Never"
            container {
              name              = "scheduler"
              image             = "227120241369.dkr.ecr.us-west-2.amazonaws.com/scheduler:latest"
              image_pull_policy = "Always"
              command           = ["python", "./main.py"]
              env {
                name  = "duplo_action"
                value = "start"
              }

              env {
                name  = "duplo_host"
                value = "https://prod.duplocloud.net"
              }
              env {
                name  = "tenant_names"
                value = var.scheduler_tenants
              }
              env {
                name = "duplo_token"
                value_from {
                  secret_key_ref {
                    key  = "DUPLO_TOKEN"
                    name = "duplo-token"
                  }
                }
              }
            }
          }
        }
      }
    }
    schedule                      = var.startup_schedule
    concurrency_policy            = "Forbid"
    failed_jobs_history_limit     = 10
    successful_jobs_history_limit = 10

  }

  lifecycle {
    ignore_changes = [
      spec[0].job_template[0].spec[0].template[0].spec[0].container[0].image
    ]
  }
}
