resource "aws_iam_role" "this" {
  for_each = var.roles

  name               = each.key
  assume_role_policy = each.value.trust_policy_json
  description        = try(each.value.description, null)

  tags = merge(
    var.common_tags,
    each.value.tags
  )
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = {
    for item in flatten([
      for role_name, role in var.roles : [
        for policy_arn in role.managed_policy_arns : {
          key        = "${role_name}|${policy_arn}"
          role_name  = role_name
          policy_arn = policy_arn
        }
      ]
    ]) : item.key => item
  }

  role       = aws_iam_role.this[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_role_policy" "inline" {
  for_each = {
    for item in flatten([
      for role_name, role in var.roles : [
        for policy_name, policy_json in role.inline_policies : {
          key         = "${role_name}|${policy_name}"
          role_name   = role_name
          policy_name = policy_name
          policy_json = policy_json
        }
      ]
    ]) : item.key => item
  }

  name   = each.value.policy_name
  role   = aws_iam_role.this[each.value.role_name].name
  policy = each.value.policy_json
}

resource "aws_iam_user" "this" {
  for_each = var.users

  name = each.key
  path = each.value.path

  tags = merge(
    var.common_tags,
    each.value.tags
  )
}

resource "aws_iam_user_policy_attachment" "managed" {
  for_each = {
    for item in flatten([
      for user_name, user in var.users : [
        for policy_arn in user.managed_policy_arns : {
          key        = "${user_name}|${policy_arn}"
          user_name  = user_name
          policy_arn = policy_arn
        }
      ]
    ]) : item.key => item
  }

  user       = aws_iam_user.this[each.value.user_name].name
  policy_arn = each.value.policy_arn
}
