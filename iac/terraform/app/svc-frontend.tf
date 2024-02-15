resource "duplocloud_duplo_service" "frontend" {
  tenant_id                            = local.tenant_id
  name                                 = "frontend"
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
        "Name" : "DUPLO",
        "Value" : "true"
      }
    ]
    }
  )
  docker_image = var.svc_frontend_docker_image
  lifecycle {
    ignore_changes = [
      docker_image
    ]
  }
}

resource "duplocloud_duplo_service_lbconfigs" "frontend_config" {
  tenant_id                   = duplocloud_duplo_service.frontend.tenant_id
  replication_controller_name = duplocloud_duplo_service.frontend.name
  lbconfigs {
    lb_type          = 7
    is_native        = false
    is_internal      = false
    port             = 3000
    external_port    = 3000
    protocol         = "http"
    health_check_url = "/"
  }
}
