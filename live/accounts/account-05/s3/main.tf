module "s3" {
  source = "../../../../modules/s3"

  buckets     = var.buckets
  common_tags = var.common_tags
}
