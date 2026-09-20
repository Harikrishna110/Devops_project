aws_region          = "us-east-1"
account_id          = "260317865213"
terraform_role_arn  = "arn:aws:iam::260317865213:role/TerraformExecutionRole"
common_tags = {
  ManagedBy = "Terraform"
  Account   = "account-01"
  Service   = "s3"
}
buckets = {
  "primary" = {
    bucket_name        = "haabc-terraform-state-prod411"
    versioning_enabled = true
    block_public_access = true
    object_ownership   = "BucketOwnerEnforced"
  }
}
