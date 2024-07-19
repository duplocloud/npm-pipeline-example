
resource "duplocloud_aws_load_balancer" "askduplo_dev" {
  tenant_id            = local.tenant_id
  name                 = "search"
  load_balancer_type   = "application"
  enable_access_logs   = false
  is_internal          = false
  drop_invalid_headers = false
  http_to_https_redirect = true
  idle_timeout         = 60
}

resource "duplocloud_aws_load_balancer_listener" "askduplo_dev_listener_443" {
  tenant_id          = local.tenant_id
  load_balancer_name = duplocloud_aws_load_balancer.askduplo_dev.name
  certificate_arn    = local.cert_arn
  protocol           = "HTTPS"
  port               = 443
  target_group_arn   = duplocloud_duplo_service_lbconfigs.frontend_config.lbconfigs[0].target_group_arn
}

resource "duplocloud_aws_target_group_attributes" "askduplo_dev_listener_443_tg_attributes" {
  tenant_id        = local.tenant_id
  target_group_arn = duplocloud_aws_load_balancer_listener.askduplo_dev_listener_443.target_group_arn
  attribute {
    key   = "target_group_health.unhealthy_state_routing.minimum_healthy_targets.count"
    value = "1"
  }
  attribute {
    key   = "stickiness.enabled"
    value = "false"
  }
  attribute {
    key   = "load_balancing.algorithm.anomaly_mitigation"
    value = "off"
  }
  attribute {
    key   = "target_group_health.unhealthy_state_routing.minimum_healthy_targets.percentage"
    value = "off"
  }
  attribute {
    key   = "deregistration_delay.timeout_seconds"
    value = "300"
  }
  attribute {
    key   = "target_group_health.dns_failover.minimum_healthy_targets.count"
    value = "1"
  }
  attribute {
    key   = "stickiness.type"
    value = "lb_cookie"
  }
  attribute {
    key   = "stickiness.lb_cookie.duration_seconds"
    value = "86400"
  }
  attribute {
    key   = "slow_start.duration_seconds"
    value = "0"
  }
  attribute {
    key   = "stickiness.app_cookie.duration_seconds"
    value = "86400"
  }
  attribute {
    key   = "target_group_health.dns_failover.minimum_healthy_targets.percentage"
    value = "off"
  }
  attribute {
    key   = "load_balancing.cross_zone.enabled"
    value = "use_load_balancer_configuration"
  }
  attribute {
    key   = "load_balancing.algorithm.type"
    value = "round_robin"
  }
}
resource "duplocloud_aws_load_balancer_listener" "askduplo_dev_listener_5000" {
  tenant_id          = local.tenant_id
  load_balancer_name = duplocloud_aws_load_balancer.askduplo_dev.name
  certificate_arn    = local.cert_arn
  protocol           = "HTTPS"
  port               = 5000
  target_group_arn   = duplocloud_duplo_service_lbconfigs.backend_config.lbconfigs[0].target_group_arn
}

resource "duplocloud_aws_target_group_attributes" "askduplo_dev_listener_5000_tg_attributes" {
  tenant_id        = local.tenant_id
  target_group_arn = duplocloud_aws_load_balancer_listener.askduplo_dev_listener_5000.target_group_arn
  attribute {
    key   = "target_group_health.unhealthy_state_routing.minimum_healthy_targets.count"
    value = "1"
  }
  attribute {
    key   = "stickiness.enabled"
    value = "false"
  }
  attribute {
    key   = "load_balancing.algorithm.anomaly_mitigation"
    value = "off"
  }
  attribute {
    key   = "target_group_health.unhealthy_state_routing.minimum_healthy_targets.percentage"
    value = "off"
  }
  attribute {
    key   = "deregistration_delay.timeout_seconds"
    value = "300"
  }
  attribute {
    key   = "target_group_health.dns_failover.minimum_healthy_targets.count"
    value = "1"
  }
  attribute {
    key   = "stickiness.type"
    value = "lb_cookie"
  }
  attribute {
    key   = "stickiness.lb_cookie.duration_seconds"
    value = "86400"
  }
  attribute {
    key   = "slow_start.duration_seconds"
    value = "0"
  }
  attribute {
    key   = "stickiness.app_cookie.duration_seconds"
    value = "86400"
  }
  attribute {
    key   = "target_group_health.dns_failover.minimum_healthy_targets.percentage"
    value = "off"
  }
  attribute {
    key   = "load_balancing.cross_zone.enabled"
    value = "use_load_balancer_configuration"
  }
  attribute {
    key   = "load_balancing.algorithm.type"
    value = "round_robin"
  }
}

resource "duplocloud_aws_load_balancer_listener" "slack_listener_3000" {
  tenant_id          = local.tenant_id
  load_balancer_name = duplocloud_aws_load_balancer.askduplo_dev.name
  certificate_arn    = local.cert_arn
  protocol           = "HTTPS"
  port               = 3000
  target_group_arn   = duplocloud_duplo_service_lbconfigs.slack_config.lbconfigs[0].target_group_arn
}

resource "duplocloud_aws_target_group_attributes" "slack_listener_3000_tg_attributes" {
  tenant_id        = local.tenant_id
  target_group_arn = duplocloud_aws_load_balancer_listener.slack_listener_3000.target_group_arn
  attribute {
    key   = "target_group_health.unhealthy_state_routing.minimum_healthy_targets.count"
    value = "1"
  }
  attribute {
    key   = "stickiness.enabled"
    value = "false"
  }
  attribute {
    key   = "load_balancing.algorithm.anomaly_mitigation"
    value = "off"
  }
  attribute {
    key   = "target_group_health.unhealthy_state_routing.minimum_healthy_targets.percentage"
    value = "off"
  }
  attribute {
    key   = "deregistration_delay.timeout_seconds"
    value = "300"
  }
  attribute {
    key   = "target_group_health.dns_failover.minimum_healthy_targets.count"
    value = "1"
  }
  attribute {
    key   = "stickiness.type"
    value = "lb_cookie"
  }
  attribute {
    key   = "stickiness.lb_cookie.duration_seconds"
    value = "86400"
  }
  attribute {
    key   = "slow_start.duration_seconds"
    value = "0"
  }
  attribute {
    key   = "stickiness.app_cookie.duration_seconds"
    value = "86400"
  }
  attribute {
    key   = "target_group_health.dns_failover.minimum_healthy_targets.percentage"
    value = "off"
  }
  attribute {
    key   = "load_balancing.cross_zone.enabled"
    value = "use_load_balancer_configuration"
  }
  attribute {
    key   = "load_balancing.algorithm.type"
    value = "round_robin"
  }
}
