<<<<<<< HEAD
Platform Architecture & Delivery Workflow:
------------------------------------------
1. Platform Provisioning (IaC):
-------------------------------

Terraform provisions:
---------------------
VPC (3 AZs, public/private subnets)
EKS cluster (private endpoint)
Node groups (system, CI runners, workloads)
RDS (PostgreSQL) + S3 (artifacts)
IAM roles (IRSA), security groups, network policies
Terraform state stored in S3 with DynamoDB locking.

2. Tenant Onboarding:
----------------------

New team request triggers automation.
Platform creates:
Kubernetes namespace (tenant-x)
Resource quotas and limits
RBAC roles scoped to namespace
Dedicated IAM role via IRSA
S3 bucket/prefix for artifacts
Network policies applied (default deny).

3. CI/CD Execution Flow:
-----------------------

Developer pushes code.
CI system schedules ephemeral Kubernetes runner pod.
Runner:
Uses tenant-scoped ServiceAccount
Pulls secrets via AWS Secrets Manage
Builds/tests in isolated namespace
Artifacts stored in tenant S3 location.
Runner pod terminates after job completion.

4. Runtime & Scalability:
-------------------------

Cluster Autoscaler scales nodes based on demand.
HPA scales CI runners horizontally.
Resource quotas prevent noisy-neighbor issues.
Platform scales from 20 → 50+ teams without new clusters.

5. Security & Isolation:
-------------------------

Namespace isolation per tenant
IRSA for least-privilege AWS access
NetworkPolicies restrict east-west traffic
Pod Security Standards (restricted)
Encrypted storage (EBS, RDS, S3)

6. Observability & Monitoring:
------------------------------

Workloads emit metrics/traces via OpenTelemetry.
OTel Collector enriches data with:
tenant
namespace
pipeline_id
Data exported to New Relic (OTLP).
Dashboards show:
Pipeline success rate & latency
Resource usage per tenant
Error rates & SLO compliance
Alerts fire on SLO violations.

7. Cost Control & Optimization:
-------------------------------

Shared EKS cluster
Spot instances for CI runners
Artifact lifecycle policies
Rightsizing via monitoring data
Cost allocation by tenant labels

8. Disaster Recovery:
----------------------
RDS automated backups
S3 versioning + replication
Terraform enables full rebuild
Recovery time < 1 hour
=======
# Reusable Terraform for 5 AWS Accounts

This repository is structured for **5 AWS accounts x 5 AWS services**, with an **independent Terraform root and state file for every service in every account**:

- EC2
- RDS
- IAM
- S3
- KMS

That gives you **25 independent Terraform states**.

## Repository layout

```text
terraform-aws-5accounts/
├── modules/
│   ├── ec2/
│   ├── rds/
│   ├── iam/
│   ├── s3/
│   └── kms/
└── live/
    └── accounts/
        ├── account-01/
        │   ├── ec2/
        │   ├── rds/
        │   ├── iam/
        │   ├── s3/
        │   └── kms/
        ├── account-02/
        │   └── ...
        ├── account-03/
        │   └── ...
        ├── account-04/
        │   └── ...
        └── account-05/
            └── ...
```

Each service directory is a separate Terraform root, so it has its own state key.

Example:

```text
s3://YOUR-TERRAFORM-STATE-BUCKET/account-01/ec2/terraform.tfstate
s3://YOUR-TERRAFORM-STATE-BUCKET/account-01/rds/terraform.tfstate
s3://YOUR-TERRAFORM-STATE-BUCKET/account-01/iam/terraform.tfstate
s3://YOUR-TERRAFORM-STATE-BUCKET/account-01/s3/terraform.tfstate
s3://YOUR-TERRAFORM-STATE-BUCKET/account-01/kms/terraform.tfstate
```

Repeat for accounts 02-05.

## Important design choice

The screenshots show environment-specific details such as VPC IDs, subnet IDs, security groups, instance types, IAM roles, RDS settings, KMS keys and TGW/VPC endpoint information. Those values are intentionally represented as variables/placeholders here rather than hard-coded into the reusable modules.

The reusable modules therefore contain **resource logic**, while each account/service root contains **account-specific configuration**.

## Backend

The examples use the S3 backend with S3 lock files:

```hcl
backend "s3" {
  bucket       = "YOUR-TERRAFORM-STATE-BUCKET"
  key          = "account-01/ec2/terraform.tfstate"
  region       = "eu-central-1"
  use_lockfile = true
  encrypt      = true
}
```

If your organization uses the older DynamoDB locking pattern, replace `use_lockfile` with your standard `dynamodb_table` configuration.

Create the state bucket and its security controls separately from these 25 states. Do not put the backend bucket itself into one of these service states.

## Authentication

Each root uses an AWS provider with an optional `assume_role` block. Put the role ARN for the target account in that root's `terraform.tfvars`.

For example:

```hcl
aws_region      = "eu-central-1"
account_id      = "111111111111"
terraform_role_arn = "arn:aws:iam::111111111111:role/TerraformExecutionRole"
```

For CI/CD, prefer OIDC or an equivalent short-lived credential mechanism rather than long-lived access keys.

## Usage

From one service root:

```bash
cd live/accounts/account-01/ec2

cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Then repeat independently for the other service roots.

## Recommended workflow

1. Bootstrap the Terraform state bucket and locking mechanism.
2. Configure one Terraform execution role in each AWS account.
3. Populate each account/service `terraform.tfvars`.
4. Import existing resources before managing them with Terraform.
5. Run `terraform plan` for one state at a time.
6. Keep EC2, RDS, IAM, S3 and KMS changes isolated so a change in one service does not lock or modify another service's state.

## Existing resources

If the infrastructure shown in the screenshots already exists, do **not** run `apply` against placeholder configuration.

First import the existing resources into the appropriate service state, for example:

```bash
terraform import 'module.ec2.aws_instance.this["app-01"]' i-xxxxxxxxxxxxxxxxx
```

Use the real resource IDs from AWS. The same principle applies to RDS instances, IAM roles/policies, S3 buckets and KMS keys.

>>>>>>> be490e1 (fiess added)
