output "alb_hostname_private" {
  value = aws_alb.private.dns_name
}

output "alb_hostname_public" {
  value = aws_alb.public.dns_name
}