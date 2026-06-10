# Evidence Checklist

Collect screenshots or terminal outputs for the defense.

## AWS

- AWS account region set to `eu-west-1`.
- Budget or billing alert configured.
- EC2 instance `cloud-ecommerce-dev-app` running.
- EC2 instance type and volume size.
- RDS instance `cloud-ecommerce-dev-postgres` available and not public.
- VPC subnets and security groups.
- SQS queue `cloud-ecommerce-dev-order-created`.
- SQS DLQ `cloud-ecommerce-dev-order-created-dlq`.
- SQS queue attributes showing DLQ redrive policy.
- S3 Terraform state bucket with versioning/encryption.
- DynamoDB lock table active.
- EC2 IAM role with SQS permissions.

## Screenshots

The screenshots collected for the delivery are stored in
`docs/evidence/screenshots/`.

| File | Evidence |
| --- | --- |
| [`01-aws-budget.png`](evidence/screenshots/01-aws-budget.png) | AWS budget configured for cost control. |
| [`02-ec2-instance-running.png`](evidence/screenshots/02-ec2-instance-running.png) | EC2 instance `cloud-ecommerce-dev-app` running. |
| [`03-ec2-instance-running-alt.png`](evidence/screenshots/03-ec2-instance-running-alt.png) | Additional EC2 instance list evidence. |
| [`04-ec2-instance-details.png`](evidence/screenshots/04-ec2-instance-details.png) | EC2 details, public IP, instance type and security information. |
| [`05-rds-database-available.png`](evidence/screenshots/05-rds-database-available.png) | RDS database `cloud-ecommerce-dev-postgres` available. |
| [`06-rds-database-private.png`](evidence/screenshots/06-rds-database-private.png) | RDS details showing private connectivity / not publicly accessible. |
| [`07-sqs-queues.png`](evidence/screenshots/07-sqs-queues.png) | SQS main queue and DLQ created. |
| [`08-sqs-redrive-policy.png`](evidence/screenshots/08-sqs-redrive-policy.png) | SQS redrive policy configured with DLQ. |
| [`09-s3-terraform-state-bucket-list.png`](evidence/screenshots/09-s3-terraform-state-bucket-list.png) | S3 bucket list showing Terraform state bucket. |
| [`10-s3-terraform-state-bucket-properties.png`](evidence/screenshots/10-s3-terraform-state-bucket-properties.png) | Terraform state bucket properties and versioning/encryption evidence. |
| [`11-dynamodb-lock-table-list.png`](evidence/screenshots/11-dynamodb-lock-table-list.png) | DynamoDB table list showing Terraform lock table. |
| [`12-dynamodb-lock-table-details.png`](evidence/screenshots/12-dynamodb-lock-table-details.png) | Terraform lock table details. |
| [`13-github-actions-ci-success.png`](evidence/screenshots/13-github-actions-ci-success.png) | GitHub Actions CI workflow successful. |
| [`14-github-actions-ci-jobs.png`](evidence/screenshots/14-github-actions-ci-jobs.png) | GitHub Actions CI jobs completed successfully. |
| [`15-terminal-api-validation.png`](evidence/screenshots/15-terminal-api-validation.png) | Terminal evidence showing `terraform validate` success and Terraform outputs. |
| [`00-project-guidance-notes.png`](evidence/screenshots/00-project-guidance-notes.png) | Auxiliary project notes, not primary AWS evidence. |

## Terraform

```bash
terraform -chdir=infra/envs/dev validate
terraform -chdir=infra/envs/dev output
```

## Application Demo

- Health checks for ports `8081`, `8082`, `8083`.
- Product creation response.
- Product listing response.
- Order creation response.
- Order listing response.
- Notification service log showing the processed order.
- SQS attributes showing `ApproximateNumberOfMessages = 0`.

### Validation executed on 2026-06-10

AWS account used:

```json
{
  "Account": "337058962986",
  "Arn": "arn:aws:iam::337058962986:user/cli-user"
}
```

Terraform outputs:

```text
app_public_ip = "108.130.209.64"
catalog_url = "http://108.130.209.64:8081/products"
order_url = "http://108.130.209.64:8082/orders"
order_created_queue_url = "https://sqs.eu-west-1.amazonaws.com/337058962986/cloud-ecommerce-dev-order-created"
```

Health checks:

```text
catalog-service: UP, PostgreSQL: UP
order-service: UP, PostgreSQL: UP
notification-service: UP
```

Product created:

```json
{
  "id": 2,
  "name": "AWS Demo Product",
  "description": "Produto criado para validacao final AWS",
  "price": 19.99,
  "stock": 20
}
```

Order created:

```json
{
  "id": 2,
  "productId": 2,
  "quantity": 2,
  "status": "CREATED"
}
```

SQS queue state after order creation:

```json
{
  "ApproximateNumberOfMessages": "0",
  "ApproximateNumberOfMessagesNotVisible": "0",
  "ApproximateNumberOfMessagesDelayed": "0"
}
```

DLQ state:

```json
{
  "ApproximateNumberOfMessages": "0",
  "ApproximateNumberOfMessagesNotVisible": "0",
  "ApproximateNumberOfMessagesDelayed": "0"
}
```

Pending evidence:

- Notification service log from EC2. The EC2 key pair is
  `cloud-ecommerce-dev-key`, but the private key is not present in this local
  `~/.ssh` folder.
- Recovery attempts without the original key:
  - `AmazonSSMManagedInstanceCore` was attached to the EC2 role, but the
    instance did not appear as a Systems Manager managed instance during the
    validation window.
  - EC2 Instance Connect accepted a temporary public key, but SSH login was
    rejected by the instance. This suggests EC2 Instance Connect is not active
    inside the current instance image/configuration.
  - Temporary SSH ingress for the current public IP was opened only for this
    test and then revoked.

## CI/CD

- GitHub Actions CI successful run.
- Docker images published to GHCR.
- Deploy workflow file present.
- GitHub/AWS OIDC setup if completed.

## Repository Hygiene

- `.gitignore` excludes private Terraform variables, state, private keys and
  local Ansible inventory.
- No access keys or private keys committed.
- Documentation explains cleanup after evaluation.
