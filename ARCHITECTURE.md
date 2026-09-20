# Architecture

## State isolation

There are 25 independent states:

| Account | EC2 | RDS | IAM | S3 | KMS |
|---|---|---|---|---|---|
| account-01 | separate | separate | separate | separate | separate |
| account-02 | separate | separate | separate | separate | separate |
| account-03 | separate | separate | separate | separate | separate |
| account-04 | separate | separate | separate | separate | separate |
| account-05 | separate | separate | separate | separate | separate |

This prevents an EC2 change from locking or modifying the RDS/IAM/S3/KMS state.

## Dependency guidance

Keep cross-service dependencies as IDs/ARNs passed through variables rather than direct Terraform state references whenever practical.

Examples:

- EC2 receives subnet IDs, security group IDs and instance profile names.
- RDS receives subnet IDs, security group IDs and optional KMS key ARN.
- S3 receives an optional KMS key ARN.
- IAM is account-scoped and independent.
- KMS is account-scoped and independent.

If you need a value from another state, use a controlled `terraform_remote_state` data source or, preferably for stable infrastructure identifiers, publish it through your organization's configuration/parameter system.

## Existing AWS estate

For the resources represented in the supplied screenshots, map the existing values into the `terraform.tfvars` for the corresponding account/service and import existing resources before applying.

Do not copy masked/redacted values from screenshots into code.
