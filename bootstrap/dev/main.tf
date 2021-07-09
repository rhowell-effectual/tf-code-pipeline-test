# partial config
terraform {
  backend "s3" {}
}

# provider "aws" {}

module "remote_state" {
  source = "../../modules/remote-state"

  # aws_region = "us-east-1"
  bucket_name          = "ryan-sandbox-tf-remote-state"
  environment          = "sandbox"
  force_destroy_bucket = true
  dynamo_table_name    = "ryan-sandbox-tf-lock-table"
}
#
# Outputs
#
output "s3_bucket_name" {
  value       = module.remote_state.s3_bucket_name
  description = "The S3 bucket Name"
}

output "s3_bucket_arn" {
  value       = module.remote_state.s3_bucket_arn
  description = "The S3 bucket ARN"
}

output "s3_bucket_region" {
  value       = module.remote_state.s3_bucket_region
  description = "The S3 bucket Region"
}

output "dynamodb_table_name" {
  value       = module.remote_state.dynamodb_table_name
  description = "The DynamoDB table Name"
}

output "dynamodb_table_arn" {
  value       = module.remote_state.dynamodb_table_arn
  description = "The DynamDB table ARN"
}