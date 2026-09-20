module "rds" {
  source = "../../../../modules/rds"

  instances   = var.instances
  common_tags = var.common_tags
}
