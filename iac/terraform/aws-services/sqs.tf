
resource "duplocloud_aws_sqs_queue" "sqs_queue" {
  tenant_id                   = local.tenant_id
  name                        = "database-updates"
  fifo_queue                  = false
  message_retention_seconds   = 345600
  visibility_timeout_seconds  = 30
} 

data "aws_iam_policy_document" "queue" {
  statement {
    sid       = "example-statement-ID"
    effect    = "Allow"
    resources = [duplocloud_aws_sqs_queue.sqs_queue.arn]
    actions   = ["SQS:SendMessage" ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [duplocloud_s3_bucket.search.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.duplocloud_aws_account.aws.account_id]
    }

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_sqs_queue_policy" "policy" {
  queue_url = duplocloud_aws_sqs_queue.sqs_queue.url
  policy    = data.aws_iam_policy_document.queue.json
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  
  depends_on = [ aws_sqs_queue_policy.policy ]

  bucket = duplocloud_s3_bucket.search.fullname

  queue {
    id = "sqs"
    queue_arn     = duplocloud_aws_sqs_queue.sqs_queue.arn
    events        = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
    filter_prefix = "source_documents/"
  }
}
