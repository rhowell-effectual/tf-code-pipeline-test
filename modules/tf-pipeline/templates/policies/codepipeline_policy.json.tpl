{
  "Version": "2012-10-17",
  "Statement": [
    {
     "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codebuild:ListConnectedOAuthAccounts",
        "codebuild:ListRepositories",
        "codebuild:PersistOAuthToken",
        "codebuild:ImportSourceCredentials"
      ],
      "Resource": "*"
    },
    {
    "Effect":"Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": [
        "${github_codestar_connection_arn}"
      ]
    },
    {
    "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
    "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "${codepipeline_bucket_arn}",
        "${codepipeline_bucket_arn}/*"
      ]
    },
    {
    "Effect":"Allow",
      "Action": [
        "sns:Publish"
      ],
      "Resource": [
        "${codepipeline_sns_arn}"
      ]
    }
  ]
}