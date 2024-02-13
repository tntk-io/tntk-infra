# Route53 dns record for our base domain to nginx ingress nlb
resource "aws_route53_record" "eks_domain" {
  zone_id = data.aws_route53_zone.base_domain.id
  name    = "*"
  type    = "A"

  alias {
    name                   = data.kubernetes_service.ingress_gateway.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_lb.ingress.zone_id
    evaluate_target_health = true
  }
  depends_on               = [ helm_release.ingress-nginx ]
}

# dns record validation for base_domain
resource "aws_route53_record" "eks_domain_cert_validation_dns" {
  for_each = {
    for dvo in aws_acm_certificate.eks_domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.base_domain.zone_id
}

# ACM domain certificate for tag_env + base.domain
resource "aws_acm_certificate" "eks_domain_cert" {
  domain_name               = "${var.tag_env}.${var.base_domain}"
  subject_alternative_names = ["*.${var.tag_env}.${var.base_domain}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.tag_env}.${var.base_domain}"
  }
}

# SSL/TLS certificate validation for base_domain
resource "aws_acm_certificate_validation" "eks_domain_cert_validation" {
  certificate_arn         = aws_acm_certificate.eks_domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.eks_domain_cert_validation_dns : record.fqdn]
}

data "aws_lb" "ingress" {
  name = regex(
    "(^[^-]+)",
    data.kubernetes_service.ingress_gateway.status[0].load_balancer[0].ingress[0].hostname
  )[0]
}

# Route 53 dns record for vpn
resource "aws_route53_record" "bastion_host_record" {
  zone_id = data.aws_route53_zone.base_domain.id
  name    = "bastion.${var.tag_env}.${var.base_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.bastion_host.public_ip]
}

data "aws_route53_zone" "base_domain" {
  name = var.base_domain
}
