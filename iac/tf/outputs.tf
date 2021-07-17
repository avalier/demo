
output "ecr_registry" {
  value = var.ecr_registry
}

output "alb_dns_name" {
  value = module.host.alb_dns_name
}

output "host_url" {
  value = resource.aws_route53_record.cname.name
}


#output "host" {
#  value = module.host
#}