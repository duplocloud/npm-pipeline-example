resource "duplocloud_duplo_service" "backend" {
  tenant_id                            = local.tenant_id
  name                                 = "backend"
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
        "name" : "OPENAI_API_KEY",
        "valueFrom" : {
          "secretKeyRef" : {
            "key" : "OPENAI_API_KEY",
            "name" : "openai"
          }
        }
      },
      {
        "Name" : "PERSIST_DIRECTORY",
        "Value" : "db"
      },
      {
        "Name" : "MODEL_TYPE",
        "Value" : "GPT4All"
      },
      {
        "Name" : "MODEL_PATH",
        "Value" : "models/ggml-gpt4all-j-v1.3-groovy.bin"
      },
      {
        "Name" : "EMBEDDINGS_MODEL_NAME",
        "Value" : "all-MiniLM-L6-v2"
      },
      {
        "Name" : "MODEL_N_CTX",
        "Value" : 1000
      },
      {
        "Name" : "DUPLO",
        "Value" : true
      },
      {
        "Name" : "S3_BUCKET",
        "Value" : data.terraform_remote_state.aws-services.outputs["s3_search_fullname"]
      },
      {
        "Name" : "DUPLO_FINE_TUNED_MODEL",
        "Value" : var.duplo_fine_tuned_model
      },
      {
        "Name" : "DUPLO_NATIVE_CONTEXT",
        "Value" : var.duplo_native_context
      },
      {
        "name" : "PINECONE_API_KEY",
        "valueFrom" : {
          "secretKeyRef" : {
            "key" : "PINECONE_API_KEY",
            "name" : "pinecone"
          }
        }
      },
      {
        "Name" : "PINECONE_ENV",
        "Value" : terraform.workspace == "ask-prod" ? "us-central1-gcp" : "gcp-starter"
      },
      {
        "Name" : "PINECONE_INDEX_NAME",
        "Value" : terraform.workspace == "ask-prod" ? "askduplocloud-prod" : "askduplocloud-dev"
      },
      {
        "Name" : "SQS_QUEUE_URL",
        "Value" : local.sqs_queue_url
      },
      {
        "Name" : "AWS_REGION",
        "Value" : local.region
      },
      {
        "Name" : "SQS_QUEUE_FULLNAME",
        "Value" : local.sqs_queue_fullname
      },
      {
        "Name" : "SQS_QUEUE_ARN",
        "Value" : local.sqs_queue_arn
      },

    ],
    "DeploymentStrategy" : {
      "RollingUpdate" : {
        "MaxSurge" : 1,
        "MaxUnavailable" : 0
      }
    },
    "startupProbe" : {
      "httpGet" : {
        "path" : "/health",
        "port" : 5000
      },
      "initialDelaySeconds" : 60,
      "periodSeconds" : 10,
      "failureThreshold" : 25      
    },
    "ReadinessProbe" : {
      "httpGet" : {
        "path" : "/health",
        "port" : 5000
      },
      "periodSeconds" : 5,
      "failureThreshold": 2
    },
    "LivenessProbe" : {
      "httpGet" : {
        "path" : "/health",
        "port" : 5000
      },
      "periodSeconds" : 5,
      "failureThreshold": 2
    },

    # "PodSecurityContext" : {
    #   "FsGroup" : 1000,
    #   "RunAsGroup" : 1000,
    #   "RunAsUser" : 1000,
    #   "allowPrivilegeEscalation": false
    # }
    }
  )

  docker_image = var.svc_backend_docker_image
  volumes = jsonencode([
    {
      "Name" : "storage",
      "Path" : "/app/storage",
      "Spec" : {
        "PersistentVolumeClaim" : {
          "claimName" : "storage"
        }
      }
    }
    ]
  )

  lifecycle {
    ignore_changes = [
      docker_image
    ]
  }
}

resource "duplocloud_duplo_service_lbconfigs" "backend_config" {
  tenant_id                   = duplocloud_duplo_service.backend.tenant_id
  replication_controller_name = duplocloud_duplo_service.backend.name
  lbconfigs {
    lb_type          = 7
    is_native        = false
    is_internal      = false
    port             = 5000
    external_port    = 5000
    protocol         = "http"
    health_check_url = "/health"
  }
}