variable "roles" {
  description = "IAM roles to manage. trust_policy_json must be a valid IAM trust policy."
  type = map(object({
    trust_policy_json = string
    description       = optional(string)
    managed_policy_arns = optional(set(string), [])
    inline_policies = optional(map(string), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "users" {
  description = "Optional IAM users. Prefer federation/SSO where possible."
  type = map(object({
    path                = optional(string, "/")
    managed_policy_arns = optional(set(string), [])
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
