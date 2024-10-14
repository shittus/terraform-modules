# export the acm certificate arn
# output "certificate_arn" {
#   value = aws_acm_certificate.acm_certificate.arn
# }

# export the domain name
output "domain_name" {
  value = var.domain_name
}

# Output the validated certificate ARN
output "validated_certificate_arn" {
  value = aws_acm_certificate_validation.cert_validation.certificate_arn
}