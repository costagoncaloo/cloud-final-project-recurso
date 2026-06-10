# Cloud E-Commerce Project

Mini e-commerce backend for the Cloud Information Systems final project.

The app is intentionally small because the evaluation focus is cloud engineering:
Terraform, Docker, AWS networking, RDS, SQS, Ansible, GitHub Actions, IAM and
deployment automation.

## Architecture

Services:

- `catalog-service`: REST API for products, backed by PostgreSQL.
- `order-service`: REST API for orders, backed by PostgreSQL. Publishes
  `ORDER_CREATED` events to SQS.
- `notification-service`: consumes SQS messages and processes order
  notifications.

AWS target architecture:

- Custom VPC with public and private subnets.
- Public EC2 running Docker containers.
- Private RDS PostgreSQL instance.
- SQS queue with DLQ for order-created events.
- IAM instance role scoped to SQS operations.
- Terraform for infrastructure, Ansible for EC2 configuration, GitHub Actions for
  CI/CD.

## Local Demo

Requirements:

- Docker Desktop
- JDK 21
- Terraform and Ansible for the AWS phase

Start the full local stack:

```bash
make up
```

Create a product and an order:

```bash
make demo-order
```

Watch the services:

```bash
make logs
```

Stop local services:

```bash
make down
```

## AWS Setup Checklist

Do this before `terraform apply`:

1. Enable MFA on the AWS root account.
2. Create a billing alarm.
3. Pick one region, currently `eu-west-1`.
4. Create a remote Terraform state S3 bucket with versioning, encryption and
   public access blocked.
5. Create a DynamoDB lock table with partition key `LockID` as string.
6. Configure GitHub OIDC and add `AWS_ROLE_TO_ASSUME` as a repository secret.
7. Create or choose an EC2 key pair.
8. Copy `infra/envs/dev/backend.tf.example` to `infra/envs/dev/backend.tf` and
   replace the placeholders.
9. Copy `infra/envs/dev/terraform.tfvars.example` to
   `infra/envs/dev/terraform.tfvars` and replace the placeholders.

## Deploy Manually

```bash
cd infra/envs/dev
terraform init
terraform plan
terraform apply
terraform output
```

Create `ansible/inventory.ini` from the example using the EC2 public IP:

```bash
cp ansible/inventory.ini.example ansible/inventory.ini
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml
```

## Mandatory Requirements Mapping

- Cloud infrastructure: `infra/envs/dev` and Terraform modules.
- Infrastructure as Code: Terraform modules under `infra/modules`.
- Containerization: one Dockerfile per service and Docker Compose for local dev.
- Distributed architecture: three Spring Boot services.
- Event-driven communication: `order-service -> SQS -> notification-service`.
- Persistence: PostgreSQL locally, RDS PostgreSQL in AWS.
- Automation/config management: Ansible deploy playbook.
- CI/CD: `.github/workflows/ci.yml` and `.github/workflows/deploy.yml`.
- Security/permissions: IAM roles, no AWS keys in code, private RDS subnet,
  restricted SSH CIDR.
