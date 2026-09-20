resource "aws_instance" "this" {
  for_each = var.instances

  ami                         = each.value.ami_id
  instance_type               = each.value.instance_type
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids     = each.value.security_group_ids
  key_name                    = try(each.value.key_name, null)
  iam_instance_profile       = try(each.value.iam_instance_profile, null)
  user_data                   = try(each.value.user_data, null)
  ebs_optimized               = each.value.ebs_optimized
  monitoring                  = each.value.monitoring
  disable_api_termination     = each.value.disable_api_termination
  private_ip                  = try(each.value.private_ip, null)

  root_block_device {
    volume_type           = each.value.root_volume_type
    volume_size           = each.value.root_volume_size
    iops                   = each.value.root_volume_iops
    throughput             = each.value.root_volume_throughput
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(
    var.common_tags,
    each.value.tags,
    { Name = each.key }
  )
}
