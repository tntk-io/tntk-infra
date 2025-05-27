#####################################
### Attention!!!
#####################################
# Datadog integration. Datadog is no longer maintaining the CloudFormation stack for Terraform. 
# As a workaround, you can set it up manually on the Datadog console.
# Refer to this doc https://docs.datadoghq.com/getting_started/integrations/aws/

resource "aws_cloudformation_stack" "DatadogIntegration" {
  name = "DatadogIntegration"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    APIKey = var.datadog_api_key
    APPKey = var.datadog_application_key
    DatadogSite = var.datadog_region
    InstallLambdaLogForwarder = true
    IAMRoleName = "DatadogIntegrationRole"
    CloudSecurityPostureManagement = false
    DisableMetricCollection = false
  }
  template_url = "https://datadog-cloudformation-template-quickstart.s3.amazonaws.com/aws/main_v2.yaml"

  lifecycle {
    ignore_changes = [
      parameters["APIKey"],
      parameters["APPKey"]
    ]
  }
}
