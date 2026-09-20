variable "aws_region" { type = string }
variable "account_id" { type = string }
variable "terraform_role_arn" { type = string }
variable "common_tags" { type = map(string) default = {} }

variable "roles" {
  type = map(object({
    trust_policy_json   = string
    description         = optional(string)
    managed_policy_arns = optional(set(string), [])
    inline_policies     = optional(map(string), {})
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "users" {
  type = map(object({
    path                = optional(string, "/")
    managed_policy_arns = optional(set(string), [])
    tags                = optional(map(string), {})
  }))
  default = {}
}
