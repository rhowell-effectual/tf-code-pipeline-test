#
# Variables
#
variable "environment_prefix"    { default = "dev" }
variable "github_branch"         { default = null }
variable "github_repo"           { default = null }
variable "state_bucket_name"     { default = null }
variable "state_lock_table_name" { default = null }
variable "terraform_destroy"     { default = false }
variable "terraform_version"     { default = false }

terraform {
  backend "s3" {}
}

# provider "aws" {
#   region = "us-east-1"
# }

locals {
  common_tags = {
    Environment = var.environment_prefix
    Terraform = "managed"
  }
}

#
# CICD Codepipeline for Terraform IaC
#
data "aws_s3_bucket" "remote_state" {
  bucket = var.state_bucket_name
}

data "aws_dynamodb_table" "remote_state_lock" {
  name = var.state_lock_table_name
}

module "codepipeline" {
  source   = "../../modules/tf-pipeline"

  auto_apply           = false
  name                 = "${var.environment_prefix}-tf"
  state_bucket_arn     = data.aws_s3_bucket.remote_state.arn
  state_lock_table_arn = data.aws_dynamodb_table.remote_state_lock.arn
  tags                 = local.common_tags
  terraform_version    = var.terraform_version
  working_directory    = "env/dev"

  environment = {
    TF_DESTROY = var.terraform_destroy ? 1 : 0
  }

  github_repo = {
      repo_path = var.github_repo
      branch    = var.github_branch
  }
}

#
# ECR Repositorie(s) for image build(s)
#
