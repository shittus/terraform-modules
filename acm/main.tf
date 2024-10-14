# Create the ACM certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  subject_alternative_names = [var.alternative_names]
  validation_method = "DNS"
}

data "aws_route53_zone" "route53_zone" {
  name         = var.domain_name
  private_zone = false
}

# Create Route 53 DNS validation records
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }


  zone_id        = data.aws_route53_zone.route53_zone.zone_id
  name           = each.value.name
  type           = each.value.type
  ttl            = 60
  records        = [each.value.value]
  allow_overwrite = true
}


# ACM certificate validation after DNS records are created
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]

  depends_on = [aws_route53_record.acm_validation]  # Ensures validation waits for DNS records
}