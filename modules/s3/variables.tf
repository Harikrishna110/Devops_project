variable "buckets" {
  description = "S3 buckets to manage."
  type = map(object({
    bucket_name                 = string
    force_destroy               = optional(bool, false)
    versioning_enabled          = optional(bool, true)
    kms_key_arn                 = optional(string)
    block_public_access         = optional(bool, true)
    object_ownership            = optional(string, "BucketOwnerEnforced")
    tags                        = optional(map(string), {})
  }))
  default = {}
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
