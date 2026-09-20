variable "aws_region" { type = string }
variable "account_id" { type = string }
variable "terraform_role_arn" { type = string }
variable "common_tags" { type = map(string) default = {} }

variable "buckets" {
  type = map(object({
    bucket_name         = string
    force_destroy       = optional(bool, false)
    versioning_enabled  = optional(bool, true)
    kms_key_arn         = optional(string)
    block_public_access = optional(bool, true)
    object_ownership    = optional(string, "BucketOwnerEnforced")
    tags                = optional(map(string), {})
  }))
  default = {}
}
