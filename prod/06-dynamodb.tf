#####################################
### DynamoDB MODULE
#####################################

module "dynamodb" {
  source = "terraform-aws-modules/dynamodb-table/aws"
  version      = "4.0.0"
  create_table = true

  name = "${var.tag_env}-pdf-files-per-user-descriptors"

  attributes = [
    {
      name = "username"
      type = "S"
    }
  ]
  hash_key = "username"

  tags = {
    Environment = "${var.tag_env}"
  }
}

# saving dynamodb table name into ssm
resource "aws_ssm_parameter" "save_dynamodb_table_name_to_ssm" {
  name        = "/${var.tag_env}/dynamodb/table_name"
  description = "The URL for the created Amazon DynamoDB table name"
  type        = "SecureString"
  value       = "${var.tag_env}-pdf-files-per-user-descriptors"
}
