{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "codestar-connections:GetConnection",
        "codestar-connections:ListTagsForResource"
      ],
      "Resource": [
        "${github_codestar_connection_arn}"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": [
        "${remote_state_dynamodb_arn}"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "iam:GetRole",
        "iam:ListRolePolicies",
        "iam:GetRolePolicy",
        "*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
        "${codepipeline_bucket_arn}",
        "${codepipeline_bucket_arn}/*",
        "${remote_state_bucket_arn}",
        "${remote_state_bucket_arn}/*"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:ListTagsForResource"
      ],
      "Resource": [
        "${codepipeline_sns_arn}"
      ]
    }
  ]
}