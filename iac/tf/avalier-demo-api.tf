
module "avalier-demo-api" {
  source       = "./modules/bhp-container-deployment"
  name         = "avalier-demo-api"
  host         = module.host
  app_image    = "${var.ecr_registry}/avalier-demo-api:dev"
  app_port     = 5000
  app_path     = "/api/*"
  app_health   = "/api/health"
  app_priority = 100
}
