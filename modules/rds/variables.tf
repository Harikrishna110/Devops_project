variable "instances" {
  description = "RDS DB instances to manage."
  type = map(object({
    identifier                  = string
    engine                      = string
    engine_version              = optional(string)
    instance_class              = string
    allocated_storage            = optional(number, 20)
    max_allocated_storage        = optional(number)
    storage_type                 = optional(string, "gp3")
    storage_encrypted            = optional(bool, true)
    kms_key_id                   = optional(string)
    db_name                      = optional(string)
    username                     = optional(string)
    port                         = optional(number)
    subnet_ids                   = list(string)
    vpc_security_group_ids       = list(string)
    multi_az                     = optional(bool, false)
    publicly_accessible          = optional(bool, false)
    deletion_protection          = optional(bool, true)
    backup_retention_period      = optional(number, 7)
    backup_window                = optional(string)
    maintenance_window           = optional(string)
    auto_minor_version_upgrade   = optional(bool, true)
    copy_tags_to_snapshot        = optional(bool, true)
    skip_final_snapshot          = optional(bool, false)
    final_snapshot_identifier    = optional(string)
    apply_immediately            = optional(bool, false)
    parameter_group_name         = optional(string)
    option_group_name            = optional(string)
    tags                         = optional(map(string), {})
  }))
  sensitive = false
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
