module "iam" {
  source = "../../../../modules/iam"

  roles       = var.roles
  users       = var.users
  common_tags = var.common_tags
}
