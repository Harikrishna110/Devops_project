module "kms" {
  source = "../../../../modules/kms"

  keys        = var.keys
  common_tags = var.common_tags
}
