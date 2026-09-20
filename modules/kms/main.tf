resource "aws_kms_key" "this" {
  for_each = var.keys

  description             = try(each.value.description, null)
  deletion_window_in_days = each.value.deletion_window_in_days
  enable_key_rotation     = each.value.enable_key_rotation
  multi_region            = each.value.multi_region
  policy                  = try(each.value.policy_json, null)

  tags = merge(
    var.common_tags,
    each.value.tags,
    { Name = each.key }
  )
}

resource "aws_kms_alias" "this" {
  for_each = {
    for k, v in var.keys : k => v if try(v.alias_name, null) != null
  }

  name          = each.value.alias_name
  target_key_id = aws_kms_key.this[each.key].key_id
}
