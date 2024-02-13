#####################################
### LAMBDA MODULE
#####################################

module "iam_assumable_role_for_lambda_execution" {
  source                            = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                           = "5.33.1"
  create_role                       = true
  role_name                         = "${var.tag_env}-lambda-execution-role"
  create_instance_profile           = true
  role_requires_mfa                 = false
  trusted_role_services             = ["lambda.amazonaws.com"]
  custom_role_policy_arns           = [module.iam_policy_for_lambda_execution.arn]
  number_of_custom_role_policy_arns = 1
}

## IAM policy module
module "iam_policy_for_lambda_execution" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "~> 5.33.1"
  name        = "${var.tag_env}-lambda-execution-policy"
  path        = "/"
  description = "For lambda execution"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes"
            ],
            "Resource": [
                "${module.sqs.queue_arn}"
            ],
            "Effect": "Allow"
        },
        {
            "Action": "s3:*",
            "Resource": ["${module.s3_bucket_for_output_files.s3_bucket_arn}", "${module.s3_bucket_for_output_files.s3_bucket_arn}/*"],
            "Effect": "Allow"
        },
        {
            "Action": "dynamodb:*",
            "Resource": "${module.dynamodb.dynamodb_table_arn}",
            "Effect": "Allow"
        }
    ]
}
EOF
}

# saving iam role arn in ssm
resource "aws_ssm_parameter" "save_lambda_iam_role_arn_to_ssm" {
  name        = "/${var.tag_env}/lambda/iam/role/arn"
  description = "The ARN of the IAM Role for Lambda execution"
  type        = "SecureString"
  value       = module.iam_assumable_role_for_lambda_execution.iam_role_arn
}
