#####################################
### S3 MODULE
#####################################

module "s3_bucket_for_output_files" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version       = "4.1.0"
  create_bucket = true
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  bucket        = "${var.tag_env}-app-output-files-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true
}

# saving s3 bucket output files into ssm
resource "aws_ssm_parameter" "save_name_of_s3_for_output_files_to_ssm" {
  name        = "/${var.tag_env}/s3_bucket/for_output_files/name"
  description = "The URL for the created Amazon SQS queue"
  type        = "SecureString"
  value       = "${var.tag_env}-app-output-files-${data.aws_caller_identity.current.account_id}"
}

