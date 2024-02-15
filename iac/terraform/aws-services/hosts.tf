
data "duplocloud_native_host_image" "ami" {
  tenant_id     = data.terraform_remote_state.tenant.outputs.tenant_id
  is_kubernetes = true
}

# in non-prod environments we will use a single instance, this will allow us to easily use a scheduler to shutdown the instance durring off hours
resource "duplocloud_aws_host" "hosts" {

  count = terraform.workspace == "ask-prod" ? 0 : 1

  tenant_id           = local.tenant_id
  friendly_name       = "host"
  image_id            = data.duplocloud_native_host_image.ami.image_id
  capacity            = var.asg_instance_type
  agent_platform      = 7
  zone                = 1
  is_minion           = true
  is_ebs_optimized    = false
  encrypt_disk        = false
  allocated_public_ip = false
  cloud               = 0
  keypair_type        = 2

  metadata {
    key   = "OsDiskSize"
    value = var.asg_os_disk_size
  }
}

module "nodegroup" {

  count = terraform.workspace == "ask-prod" ? 1 : 0

  source             = "duplocloud/components/duplocloud//modules/eks-nodes"
  version            = "0.0.5"
  tenant_id          = local.tenant_id
  os_disk_size       = var.asg_os_disk_size
  eks_version        = data.duplocloud_plan.plan.kubernetes_config[0]["version"]

  az_list            = var.az_list
  capacity           = var.asg_instance_type
  instance_count     = var.asg_instance_count
  min_instance_count = var.asg_instance_count
  max_instance_count = var.asg_instance_count  
}
