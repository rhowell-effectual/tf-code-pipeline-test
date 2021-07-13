# Codebuild IAM Assume Role Policy template
data "template_file" "assume_role_policy" {
  template = file("${path.module}/templates/policies/codebuild_assume_role_policy.json.tpl")
}

# Codebuild IAM Role
resource "aws_iam_role" "codebuild" {
  name               = "${local.namespace}-codebuild"
  assume_role_policy = "${data.template_file.assume_role_policy.rendered}"
  tags               = var.tags
}

# Codebuild IAM Policy template
data "template_file" "codebuild_policy" {
  template = file("${path.module}/templates/policies/codebuild_policy.json.tpl")

  vars = {
    codepipeline_bucket_arn        = "${aws_s3_bucket.codepipeline.arn}"
    codepipeline_sns_arn           = "${aws_sns_topic.codepipeline.arn}"
    github_codestar_connection_arn = "${aws_codestarconnections_connection.github.arn}"
    remote_state_bucket_arn        = "${var.state_bucket_arn}"
    remote_state_dynamodb_arn      = "${var.state_lock_table_arn}"
  }
}

# Codebuild IAM Policy (Codebuild permissions)
resource "aws_iam_role_policy" "codebuild" {
  role   = aws_iam_role.codebuild.name
  policy = "${data.template_file.codebuild_policy.rendered}"
}

# Codepipeline IAM Assume Role Policy template
data "template_file" "cp_assume_role_policy" {
  template = file("${path.module}/templates/policies/codepipeline_assume_role_policy.json.tpl")
}

# Codepiepline IAM Role
resource "aws_iam_role" "codepipeline" {
  name               = "${local.namespace}-codepipeline"
  assume_role_policy = "${data.template_file.cp_assume_role_policy.rendered}"
  tags               = var.tags
}

# Codepipeline IAM Policy template
data "template_file" "cp_codebuild_policy" {
  template = file("${path.module}/templates/policies/codepipeline_policy.json.tpl")

  vars = {
    codepipeline_bucket_arn        = "${aws_s3_bucket.codepipeline.arn}"
    codepipeline_sns_arn           = "${aws_sns_topic.codepipeline.arn}"
    github_codestar_connection_arn = "${aws_codestarconnections_connection.github.arn}"
  }
}

# Codepipeline IAM Policy (Codepipeline permissions)
resource "aws_iam_role_policy" "cp_codebuild_policy" {
  role   = aws_iam_role.codepipeline.id
  policy = "${data.template_file.cp_codebuild_policy.rendered}"
}

#
# Outputs
#
output "deployment_role_arn" {
  value = aws_iam_role.codebuild.arn
}