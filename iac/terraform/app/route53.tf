
data "aws_route53_zone" "route53" {
  name         = var.base_domain
  private_zone = false
}

data "aws_lb" "lb" {
  name = duplocloud_aws_load_balancer.askduplo_dev.fullname
}

resource "aws_route53_record" "alias" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = var.tenant
  type    = "A"

  alias {
    name                   = duplocloud_aws_load_balancer.askduplo_dev.dns_name
    zone_id                = data.aws_lb.lb.zone_id
    evaluate_target_health = false
  }
}

# production, that is running on a VM, uses the following URL for the backend
# https://search.prod-apps.duplocloud.net:5000
# To test the container production environment, and to enable quick rollback
# I am going to start controlling the value for this DNS record in this TF

resource "aws_route53_record" "alias-old" {

  # only create this resource if we are dealing with the production environment
  count = var.tenant == "ask-prod" ? 1 : 0

  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "search"
  type    = "A"

  alias {
    name                   = var.prod_containerized == false ? "duplo3-search-search-1016995356.us-west-2.elb.amazonaws.com" : duplocloud_aws_load_balancer.askduplo_dev.dns_name
    zone_id                = data.aws_lb.lb.zone_id
    evaluate_target_health = false
  }
}