variable "base_domain" {
  type    = string
  description = "Base domain for our DNS records"
}

variable "aws_region" {
  type    = string
  description = "AWS region to create our resources"
}

variable "tag_env" {
  description = "tag environment for out all resources"
}

variable "id_rsa" {
  type    = string
  description = "Public ssh key for ec2 instances"
}

variable "datadog_api_key" {
  type        = string
  description = "datadog api key"
}

variable "datadog_application_key" {
  type        = string
  description = "datadog application key"
}

variable "datadog_region" {
  type = string
  description = "datadog region"
}

#####################################
### CICD variables
#####################################

# required github token
variable "registrationToken" {
  type    = string
  description = "registration token to register github runner for CI"
}

variable "ci_project_repo" {
  type    = string
  description = "CI project repo to register github runner"
}

variable "cd_project_repo" {
  type    = string
  description = "argo CD project repo"
}
