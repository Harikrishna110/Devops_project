resource "aws_db_subnet_group" "this" {
  for_each = var.instances

  name       = "${each.value.identifier}-subnet-group"
  subnet_ids = each.value.subnet_ids

  tags = merge(
    var.common_tags,
    each.value.tags,
    { Name = "${each.value.identifier}-subnet-group" }
  )
}

resource "aws_db_instance" "this" {
  for_each = var.instances

  identifier = each.value.identifier
  engine     = each.value.engine

  engine_version = try(each.value.engine_version, null)
  instance_class = each.value.instance_class

  allocated_storage     = each.value.allocated_storage
  max_allocated_storage = try(each.value.max_allocated_storage, null)
  storage_type          = each.value.storage_type
  storage_encrypted     = each.value.storage_encrypted
  kms_key_id            = try(each.value.kms_key_id, null)

  db_name  = try(each.value.db_name, null)
  username = try(each.value.username, null)
  port     = try(each.value.port, null)

  db_subnet_group_name   = aws_db_subnet_group.this[each.key].name
  vpc_security_group_ids = each.value.vpc_security_group_ids

  multi_az                   = each.value.multi_az
  publicly_accessible        = each.value.publicly_accessible
  deletion_protection        = each.value.deletion_protection
  backup_retention_period    = each.value.backup_retention_period
  backup_window              = try(each.value.backup_window, null)
  maintenance_window         = try(each.value.maintenance_window, null)
  auto_minor_version_upgrade = each.value.auto_minor_version_upgrade
  copy_tags_to_snapshot      = each.value.copy_tags_to_snapshot
  skip_final_snapshot        = each.value.skip_final_snapshot
  final_snapshot_identifier  = try(each.value.final_snapshot_identifier, null)
  apply_immediately           = each.value.apply_immediately
  parameter_group_name        = try(each.value.parameter_group_name, null)
  option_group_name           = try(each.value.option_group_name, null)

  tags = merge(
    var.common_tags,
    each.value.tags,
    { Name = each.value.identifier }
  )
}
