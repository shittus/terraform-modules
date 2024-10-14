# export the acm certificate arn
output "certificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}

# export the domain name
output "domain_name" {
  value = aws_acm_certificate.acm_certificate.name
}