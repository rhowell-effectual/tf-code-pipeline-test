# Add docs
#

#
# Inputs
#
variable "bucket_name"                  { default = null }
variable "environment"                  { default = null }
variable "force_destroy_bucket"         { default = null }
variable "dynamo_table_name"            { default = null }

#
# Resources
#
resource "aws_s3_bucket" "state_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy_bucket

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
      Application = "terraform-remote-state"
      Environment = var.environment
      Name        = var.bucket_name
      Terraform   = "managed"
  }
}

resource "aws_dynamodb_table" "state_lock" {
  name         = var.dynamo_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
      Application = "terraform-remote-state"
      Environment = var.environment
      Name        = var.dynamo_table_name
      Terraform   = "managed"

  }
}

#
# Outputs
#
output "s3_bucket_name" {
  value       = aws_s3_bucket.state_bucket.id
  description = "The S3 bucket Name"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.state_bucket.arn
  description = "The S3 bucket ARN"
}

output "s3_bucket_region" {
  value       = aws_s3_bucket.state_bucket.region
  description = "The S3 bucket Region"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.state_lock.name
  description = "The DynamoDB table Name"
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.state_lock.arn
  description = "The DynamDB table ARN"
}