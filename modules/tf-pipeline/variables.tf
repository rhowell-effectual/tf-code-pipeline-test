variable "name" {
  type        = string
  default     = "test"
  description = "A project name to use for resource mapping"
}

variable "auto_apply" {
  type        = bool
  default     = false
  description = "Whether to automatically apply changes when a Terraform plan is successful. Defaults to false."
}

variable "terraform_version" {
  type        = string
  default     = "latest"
  description = "The version of Terraform to use for this pipeline. Defaults to the latest available version."
}

variable "working_directory" {
  type        = string
  default     = "."
  description = "A relative path that Terraform will execute within. Defaults to the root of the repository."
}

variable "github_repo" {
  type        = object({ repo_path = string, branch = string })
  description = "Settings for the source GitHub repository."
}

variable "environment" {
  type        = map(string)
  default     = {}
  description = "A map of environment variables to pass into pipeline"
}

variable "deployment_policy" {
  type        = string
  default     = null
  description = "An optional IAM deployment policy"
}

variable "state_bucket_arn" {
  type        = string
  default     = null
  description = "S3 bucket containing remote state"
}

variable "state_lock_table_arn" {
  type        = string
  default     = null
  description = "S3 bucket containing remote state"
}