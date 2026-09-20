module "ec2" {
  source = "../../../../modules/ec2"

  instances   = var.instances
  common_tags = var.common_tags
}
