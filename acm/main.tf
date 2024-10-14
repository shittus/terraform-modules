# # request public certificates from the amazon certificate manager.
# resource "aws_acm_certificate" "acm_certificate" {
#   domain_name               = var.domain_name
#   subject_alternative_names = [var.alternative_names]
#   validation_method         = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # get details about a route 53 hosted zone
# data "aws_route53_zone" "route53_zone" {
#   name         = var.domain_name
#   private_zone = false
# }

# # create a record set in route 53 for domain validatation
# resource "aws_route53_record" "route53_record" {
#   for_each = {
#     for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.route53_zone.zone_id
# }

# # validate acm certificates
# resource "aws_acm_certificate_validation" "acm_certificate_validation" {
#   certificate_arn         = aws_acm_certificate.acm_certificat.arn
#   validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
# }


# Data Source for ACM Certificate
# Fetch details of an existing ACM certificate
data "aws_acm_certificate" "existing_cert" {
  domain   = var.domain_name
  statuses = ["ISSUED"]  # Fetch an issued certificate
}

# Get details about the Route 53 hosted zone
data "aws_route53_zone" "route53_zone" {
  name         = var.domain_name
  private_zone = false
}

# Route 53 DNS record for ACM certificate validation
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in data.aws_acm_certificate.existing_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  zone_id = data.aws_route53_zone.route53_zone.zone_id  # Correct reference
  name    = ws_acm_certificate_validation.cert_validation.namd
  type    = "CNAME"
  ttl     = 60
  records = [aws_acm_certificate_validation.cert_validation.id]
}

# # Wait for ACM certificate validation to complete
# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = data.aws_acm_certificate.existing_cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
# }

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = data.aws_acm_certificate.existing_cert.arn
  validation_record_fqdns = [aws_route53_record.acm_validation.fqdn]
}

