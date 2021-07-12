#
# Doc this...
#
locals {
#   backend = templatefile("${path.module}/templates/backend.json", { config : var.s3_backend_config, name : local.namespace })
  namespace = substr(join("-", [var.name, random_string.rand.result]), 0, 24)
  projects = ["plan", "apply"]

  default_environment = {
    TF_IN_AUTOMATION  = "1"
    TF_INPUT          = "0"
    TF_DESTROY   = "0"
    WORKING_DIRECTORY = var.working_directory
  }

  environment = jsonencode([for k, v in merge(local.default_environment,  var.environment) : { name : k, value : v, type : "PLAINTEXT" }])
}

#
# Resources
#
resource "random_string" "rand" {
  length  = 24
  special = false
  upper   = false
}

resource "aws_codebuild_project" "plan" {
  name         = "${local.namespace}-plan"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform:${var.terraform_version}"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/templates/buildspec_plan.yml")
  }
}

resource "aws_codebuild_project" "apply" {
  name         = "${local.namespace}-apply"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform:${var.terraform_version}"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/templates/buildspec_apply.yml")
  }
}

resource "aws_s3_bucket" "codepipeline" {
  bucket        = "${local.namespace}-codepipeline"
  acl           = "private"
  force_destroy = true
}

resource "aws_sns_topic" "codepipeline" {
  name = "${local.namespace}-codepipeline"
}

resource "aws_codestarconnections_connection" "github" {
  name          = "${local.namespace}-github"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${local.namespace}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        FullRepositoryId = var.github_repo.repo_path
        BranchName       = var.github_repo.branch
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name            = "Plan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.plan.name
        EnvironmentVariables = local.environment
      }
    }
  }

  dynamic "stage" {
    for_each = var.auto_apply ? [] : [1]
    content {
      name = "Approval"

      action {
        name     = "Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          CustomData      = "Please review output of plan and approve"
          NotificationArn = aws_sns_topic.codepipeline.arn
        }
      }
    }
  }

  stage {
    name = "Apply"

    action {
      name            = "Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.apply.name
        EnvironmentVariables = local.environment
      }
    }
  }
}