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