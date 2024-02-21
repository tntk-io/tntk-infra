#####################################
### HELM RELEASES
#####################################

# helm chart for amazon lambda controller
resource "helm_release" "ack-lambda" {
  name             = "ack-lambda"
  repository       = "oci://public.ecr.aws/aws-controllers-k8s"
  version          = "1.4.0"
  chart            = "lambda-chart"
  namespace        = "ack-lambda"
  create_namespace = "true"
  timeout          = 600

  set {
    name  = "aws.region"
    value = var.aws_region
    type  = "string"
  }

  set {
    name  = "defaultResyncPeriod"
    value = "0"
    type  = "string"
  }

  depends_on = [module.eks]
}

resource "helm_release" "crd-helm-chart" {
  name             = "crd-helm-chart"
  chart            = "./crd-helm-chart"
  namespace        = "crd-helm-chart"
  create_namespace = "true"
  set {
    name  = "tag_env"
    value = var.tag_env
    type  = "string"
  }
  set {
    name  = "projectrepo"
    value = var.ci_project_repo
    type  = "string"
  }
  set {
    name  = "aws_account_id"
    value = data.aws_caller_identity.current.account_id
    type  = "string"
  }
  set {
    name  = "aws_region"
    value = var.aws_region
    type  = "string"
  }
  
  depends_on = [helm_release.actions-runner-controller, helm_release.ack-lambda, module.eks]
}

# helm chart cert-manager requirments for actions runner contoller
resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  namespace        = "cert-manager"
  version          = "1.14.1"
  create_namespace = "true"
  set {
    name  = "installCRDs"
    value = "true"
    type  = "string"
  }

  depends_on = [module.eks]
}

# github actions runner creation helm chart
resource "helm_release" "actions-runner-controller" {
  name             = "actions-runner-controller"
  chart            = "actions-runner-controller"
  repository       = "https://actions-runner-controller.github.io/actions-runner-controller"
  namespace        = "actions-runner-system"
  version          = "0.23.7"
  create_namespace = "true"

  set {
    name  = "authSecret.create"
    value = "true"
    type  = "string"
  }
  set {
    name  = "authSecret.github_token"
    value = var.registrationToken
    type  = "string"
  }

  depends_on = [helm_release.cert-manager, module.eks]
}

# nginx ingress controller helm chart
resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.9.1"
  namespace  = "ingress-nginx"
  create_namespace = "true"
  timeout    = 600
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout"
    value = "60"
    type  = "string"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
    type  = "string"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = aws_acm_certificate.eks_domain_cert.arn
    type  = "string"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = "https"
    type  = "string"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-negotiation-policy"
    value = "ELBSecurityPolicy-TLS-1-2-2017-01"
    type  = "string"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
    type  = "string"
  }
  set {
    name  = "controller.service.targetPorts.http"
    value = "http"
    type  = "string"
  }
  set {
    name  = "controller.service.targetPorts.https"
    value = "http"
    type  = "string"
  }
  set {
    name  = "controller.admissionWebhooks.enabled"
    value = "false"
  }

  depends_on = [module.eks]
}

# main argocd helm chart
resource "helm_release" "argocd" {
  name             = "argocd"
  create_namespace = "true"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.53.14"
  repository       = "https://argoproj.github.io/argo-helm"
  timeout          = 300

  set {
    name  = "server.extraArgs"
    value = "{--insecure}"
  }

  set {
    name  = "server.ingress.enabled"
    value = "true"
    type  = "string"
  }

  set {
    name  = "server.ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
    type  = "string"
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/force-ssl-redirect"
    value = "false"
    type  = "string"
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/backend-protocol"
    value = "HTTP"
    type  = "string"
  }
  set {
    name  = "server.ingress.hosts"
    value = "{argo.${var.tag_env}.${var.base_domain}}"
    type  = "string"
  }

  depends_on = [module.eks]
}

# argocd-apps helm chart to create application in argocd
resource "helm_release" "argocd-apps" {
  name       = "argocd-apps"
  chart      = "argocd-apps"
  namespace  = "argocd"
  version    = "1.6.1"
  repository = "https://argoproj.github.io/argo-helm"
  timeout    = 300

  set {
    name  = "applications[0].source.repoURL"
    value = "https://github.com/${var.cd_project_repo}"
    type  = "string"
  }
  set {
    name  = "applications[0].source.targetRevision"
    value = var.tag_env
    type  = "string"
  }
  values = [
    "${file("helm-chart-values/argo-cd-apps-values.yaml")}"
  ]

  depends_on = [helm_release.argocd, module.eks]
}

# datadog helm chart
resource "helm_release" "datadog" {
  name             = "datadog"
  repository       = "https://helm.datadoghq.com"
  chart            = "datadog"
  namespace        = "datadog"
  version          = "3.53.2"
  create_namespace = "true"
  timeout          = 300
  set {
    name  = "datadog.apiKey"
    value = var.datadog_api_key
  }
  set {
    name  = "datadog.appkey"
    value = var.datadog_application_key
  }
  set {
    name  = "datadog.clusterName"
    value = module.eks.cluster_name
  }
  set {
    name  = "datadog.site"
    value = var.datadog_region
  }
  set {
    name  = "datadog.dd_url"
    value = "https://${var.datadog_region}"
  }
  set {
    name  = "datadog.logs.enabled"
    value = "true"
  }
  set {
    name  = "datadog.logs.containerCollectAll"
    value = "true"
  }

  depends_on = [module.eks]
}

data "kubernetes_service" "ingress_gateway" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = helm_release.ingress-nginx.namespace
  }

  depends_on = [helm_release.ingress-nginx, module.eks]
}