variable "instances" {
  description = "EC2 instances to manage."
  type = map(object({
    ami_id                 = string
    instance_type          = string
    subnet_id              = string
    security_group_ids     = list(string)
    key_name               = optional(string)
    iam_instance_profile   = optional(string)
    user_data              = optional(string)
    root_volume_size       = optional(number, 70)
    root_volume_type       = optional(string, "gp3")
    root_volume_iops        = optional(number, 3000)
    root_volume_throughput  = optional(number, 125)
    ebs_optimized           = optional(bool, true)
    monitoring              = optional(bool, false)
    disable_api_termination = optional(bool, false)
    private_ip              = optional(string)
    tags                    = optional(map(string), {})
  }))
}

variable "common_tags" {
  description = "Tags applied to all EC2 instances."
  type        = map(string)
  default     = {}
}
