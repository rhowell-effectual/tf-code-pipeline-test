
data "aws_s3_bucket" "remote_state" {
  bucket = "ryan-sandbox-tf-remote-state"
}

data "aws_dynamodb_table" "remote_state_lock" {
  name = "ryan-sandbox-tf-lock-table"
}

module "codepipeline" {
  source   = "../../modules/tf-pipeline"

  name                 = "ryan-sandbox-tf"
  state_bucket_arn     = data.aws_s3_bucket.remote_state.arn
  state_lock_table_arn = data.aws_dynamodb_table.remote_state_lock.arn
  terraform_version    = "0.15.0"
  working_directory    = "env/dev"

  github_repo = {
      repo_path = "rhowell-effectual/tf-code-pipeline-test"
      branch = "main"
  }
  auto_apply = false

  environment = {
    TF_DESTROY = 0
  }
}