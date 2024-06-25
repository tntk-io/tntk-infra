<!-- BEGIN_TF_DOCS -->
# Project overview

This educational project is intended for the practical application of knowledge in the field of cloud technology and DevOps, as well as the deployment of web applications with the best practices. The stack is designed to cover the maximum number of technologies and simultaneously carry the functional and meaningful load on each. This project applies a declarative approach to infrastructure building and shows the deployment automation process for the entire stack. All components of the project and their relationships are considered in detail to see how the application and its operation services work in the actual cloud on a concrete example.

Check out the video instructions for the project on https://www.udemy.com/course/real-world-devops-project-gitops-methodology

# Main goal

Gain practical Infrastructure as code (IaC) skills. Learn how to deploy such applications in the cloud cluster.

# Requirements and tools

1. Terraform cli (https://developer.hashicorp.com/terraform/install)
2. AWS account (where everything will be deployed)
3. AWS account where our host_zone is located
4. Domain (e.g. "example.com")
5. Cloud terraform account (https://app.terraform.io/session)
6. Repository access

# Infrastructure deployment

To deploy our terraform code first of all we need to create account on https://app.terraform.io/session and create organization and workspace.

1. Login to the terraform cloud. After that we need to create workspace. We need to go to "Projects & workspaces" → new workspace → create workspace click on then Version control workflow and we have to connect it with our github repository where our
   terraform code is located.
2. Select VCS provider. Select GitHub and then select GitHub.com from the menu.
3. Set up provider to connect GitHub.com to Terraform Cloud (For additional information about connecting to GitHub.com to Terraform Cloud, please read documentation - https://developer.hashicorp.com/terraform/cloud-docs/vcs).
3. Choose repository.
4. Open Advanced options.
5. Define folder with terraform code ("dev" or "prod").
6. Define branch name.
7. Create workspace.
8. Define required variables. Don't forget to define Environment variables for AWS ("AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", if you are using SSO add the "AWS_SESSION_TOKEN").
9. Start plan.
10. Apply. After planning we can confirm & apply – it will executes the changes defined by our Terraform configuration to create, update, or destroy resources. It will take about 30 min to create all resources.

# Application deployment

After deploying infrastructure we moving to application section desribed in application repository - https://github.com/tntk-io/tntk-ci.

# Removing Infrastructure

1. Login to argo CD (e.g. "https://argo.prod.example.com/") and delete "demo" application.
2. Destroy. Open "Settings" → "Destruction and Deletion" → inside "Manually destroy" block push "Queue destroy plan" button. After planning we can destroy resources – it will executes the changes defined by our Terraform configuration to destroy resources. It will take about 30 min to destroy all resources.



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://developer.hashicorp.com/terraform/install) | >= 1.4.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) | 5.35.0 |
| <a name="provider_helm"></a> [helm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) | 2.12.1 |
| <a name="provider_kubernetes"></a> [kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) | 2.25.2 |
| <a name="provider_random"></a> [random](https://registry.terraform.io/providers/hashicorp/random/latest/docs) | 3.6.0 |
| <a name="provider_cloudinit"></a> [cloudinit](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs) | 2.3.3 |
| <a name="provider_null"></a> [null](https://registry.terraform.io/providers/hashicorp/null/latest/docs) | 3.2.2 |
| <a name="provider_time"></a> [time](https://registry.terraform.io/providers/hashicorp/time/latest/docs) | 0.10.0 |
| <a name="provider_tls"></a> [tls](https://registry.terraform.io/providers/hashicorp/tls/latest/docs) | 4.0.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) | terraform-aws-modules/vpc/aws | 5.5.1 |
| <a name="module_dynamodb"></a> [dynamodb](https://registry.terraform.io/modules/terraform-aws-modules/dynamodb-table/aws/latest) | terraform-aws-modules/dynamodb-table/aws | 4.0.0 |
| <a name="module_ecr"></a> [ecr](https://registry.terraform.io/modules/cloudposse/ecr/aws/latest) | cloudposse/ecr/aws | 0.40.0 |
| <a name="module_eks"></a> [eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) | terraform-aws-modules/eks/aws | 20.2.1 |
| <a name="module_iam_assumable_role_for_lambda_execution"></a> [iam\_assumable\_role\_for\_lambda\_execution](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-assumable-role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 5.33.1 |
| <a name="module_iam_policy_for_lambda_execution"></a> [iam\_policy\_for\_lambda\_execution](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest) | terraform-aws-modules/iam/aws//modules/iam-policy | ~> 5.33.1 |
| <a name="module_rds"></a> [rds](https://registry.terraform.io/modules/cloudposse/rds-cluster/aws/latest) | cloudposse/rds-cluster/aws | 1.7.0 |
| <a name="module_s3_bucket_for_output_files"></a> [s3\_bucket\_for\_output\_files](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest) | terraform-aws-modules/s3-bucket/aws | 4.1.0 |
| <a name="module_sqs"></a> [sqs](https://registry.terraform.io/modules/terraform-aws-modules/sqs/aws/latest) | terraform-aws-modules/sqs/aws | 4.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_key_pair.devops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [random_password.rds_db_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.rds_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.rds_admin_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_ssm_parameter.save_rds_db_name_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.save_rds_endpoint_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.save_rds_password_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.save_rds_admin_username_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.save_dynamodb_table_name_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.save_name_of_s3_for_output_files_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.save_lambda_iam_role_arn_to_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.sqs_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.sqs_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.sqs_url_path](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_cloudformation_stack.DatadogIntegration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [helm_release.ack-lambda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.crd-helm-chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.actions-runner-controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress-nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.argocd-apps](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.datadog](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_service.ingress_gateway](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |
| [aws_route53_record.eks_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.eks_domain_cert_validation_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate.eks_domain_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.eks_domain_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_lb.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_route53_record.bastion_host_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.base_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [kubernetes_namespace.application](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.demo-repo](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [aws_eip.bastion_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_security_group.bastion_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_instance.bastion_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ami.latest-ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base domain for our DNS records (e.g. "example.com") | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to create our resources (e.g. "us-east-1") | `string` | n/a | yes |
| <a name="input_tag_env"></a> [tag\_env](#input\_tag\_env) | Tag environment (e.g. "prod") | `string` | n/a | yes |
| <a name="input_id_rsa"></a> [id\_rsa](#input\_id\_rsa) | Public ssh key for ec2 instances (e.g. "ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX...") | `string` | n/a | yes |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | DataDog api key. Get it at official DD web site. Region sensitive | `string` | n/a | yes |
| <a name="input_datadog_application_key"></a> [datadog\_application\_key](#input\_datadog\_application\_key) | DataDog application key. Get it at official DD web site. Region sensitive | `string` | n/a | yes |
| <a name="input_datadog_region"></a> [datadog\_region](#input\_datadog\_region) | DataDog region (e.g. "us5.datadoghq.com") | `string` | n/a | yes |
| <a name="input_registrationToken"></a> [registrationToken](#input\_registrationToken) | Token for github actions self-hosted runners (e.g. ghp\_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX) | `string` | n/a | yes |
| <a name="input_ci_project_repo"></a> [ci\_project\_repo](#input\_ci\_project\_repo) | Git repo with source files for CI (e.g. "account-name/repository-name") | `string` | n/a | yes |
| <a name="input_cd_project_repo"></a> [cd\_project\_repo](#input\_cd\_project\_repo) | Git repo with source files for CD (e.g. "account-name/repository-name") | `string` | n/a | yes |
