module "codepipeline" {
  source   = "../../modules/tf-pipeline"

  name     = "ryan-sandbox-tf"
  github_repo = {
      repo_path = "rhowell-effectual/tf-code-pipeline-test"
      branch = "main"
  }
  auto_apply = false

  environment = {
    CONFIRM_DESTROY = 1
  }

  # deployment_policy = file("../../policies/temp.json")
#   s3_backend_config = module.s3backend.config
  terraform_version = "0.15.0"
  working_directory = "env/dev"
}