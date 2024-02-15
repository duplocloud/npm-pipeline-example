
variable "asg_instance_type" {
  default = "t3.xlarge"
  type    = string
}
variable "s3_search_allow_public_access" {
  default = false
  type    = bool
}
variable "s3_search_enable_access_logs" {
  default = false
  type    = bool
}
variable "s3_search_enable_versioning" {
  default = true
  type    = bool
}

variable "asg_instance_count" {
  default = 1
  description = "Number of nodes in each ASG (one ASG per AZ)"
  type    = number
}

variable "asg_os_disk_size" {
  default = 100
  type    = string
}

# default to a single ASG so that all non production environments will have single node
variable "az_list" {
  default     = ["a"]
  type        = list(string)
  description = "The letter at the end of the zone"
}
