variable "keys" {
  description = "KMS keys and aliases to manage."
  type = map(object({
    description             = optional(string)
    deletion_window_in_days = optional(number, 30)
    enable_key_rotation     = optional(bool, true)
    multi_region            = optional(bool, false)
    policy_json              = optional(string)
    alias_name              = optional(string)
    tags                    = optional(map(string), {})
  }))
  default = {}
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
