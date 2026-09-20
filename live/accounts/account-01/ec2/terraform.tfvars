aws_region          = "us-east-1"
account_id          = "260317865213"
terraform_role_arn  = "arn:aws:iam::260317865213:role/TerraformExecutionRole"
common_tags = {
  ManagedBy = "Terraform"
  Account   = "account-01"
  Service   = "ec2"
}
instances = {
  "app-01" = {
    ami_id             = "ami-0fef201115eefe936"
    instance_type      = "t3.micro"
    subnet_id          = "subnet-0dcd807413c7128de"
    security_group_ids = ["sg-0d1b5cdf5e16768a8"]
    key_name           = "ec2"
    root_volume_size   = 70
    root_volume_type   = "gp3"
    root_volume_iops   = 3000
    root_volume_throughput = 125
    tags = {
      Name = "REPLACE_INSTANCE_NAME"
    }
  }
}
