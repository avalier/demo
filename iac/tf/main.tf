
module "host" {
  source          = "./modules/bhp-container-host"
  name            = "avalier-demo"
  aws_region      = var.aws_region
  vpc_id          = local.vpc_id
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

resource "aws_route53_record" "cname" {
  zone_id = local.zone_id
  name    = "avalier-demo.${local.zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [module.host.alb_dns_name]
}