
resource "duplocloud_aws_efs_file_system" "efs" {
  backup           = false
  encrypted        = true
  name             = "storage-${local.tenant_name}"
  performance_mode = "generalPurpose"
  tenant_id        = local.tenant_id
  throughput_mode  = "bursting"
}

resource "duplocloud_k8_storage_class" "sc" {
  tenant_id              = local.tenant_id
  name                   = "storage"
  storage_provisioner    = "efs.csi.aws.com"
  reclaim_policy         = "Retain"
  volume_binding_mode    = "Immediate"
  allow_volume_expansion = true
  parameters = {
    fileSystemId     = duplocloud_aws_efs_file_system.efs.file_system_id
    basePath         = "/dynamic_provisioning",
    directoryPerms   = "700",
    uid              = "1000",
    gid              = "2000",
    provisioningMode = "efs-ap",
  }
}

resource "duplocloud_k8_persistent_volume_claim" "pvc" {

  tenant_id = local.tenant_id
  name      = "storage"
  spec {
    access_modes       = ["ReadWriteMany"]
    volume_mode        = "Filesystem"
    storage_class_name = duplocloud_k8_storage_class.sc.fullname
    resources {
      requests = {
        storage = "100Gi"
      }
    }
  }
}
