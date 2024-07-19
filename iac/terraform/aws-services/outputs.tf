
output "s3_search_fullname" {
  value       = duplocloud_s3_bucket.search.fullname
  description = "The full name of the S3 bucket."
}
output "s3_search_arn" {
  value       = duplocloud_s3_bucket.search.arn
  description = "The ARN of the S3 bucket."
}

output "sqs_queue_fullname" {
  value       = duplocloud_aws_sqs_queue.sqs_queue.fullname
  description = "Name of the SQS queue"
}

output "sqs_queue_arn" {
  value       = duplocloud_aws_sqs_queue.sqs_queue.arn
  description = "ARN of the SQS queue"
}

output "sqs_queue_url" {
  value       = duplocloud_aws_sqs_queue.sqs_queue.url
  description = "URL of the SQS queue"
}

output "region" {
  value       = local.region
  description = "The AWS Region for the Tenant"
}
