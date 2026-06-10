# Final Checklist

Use this before submission and before the defense.

## Already Validated

- `catalog-service` health check returned `UP`.
- `order-service` health check returned `UP`.
- `notification-service` health check returned `UP`.
- Product creation worked in AWS.
- Order creation worked in AWS.
- Order creation persisted data in PostgreSQL.
- SQS queue was empty after order creation.
- DLQ was empty after order creation.
- Terraform validation passed.
- Docker Compose configuration validation passed.
- Ansible playbook syntax check passed.
- GitHub Actions CI had a successful run.

## Evidence To Capture

Screenshots have been collected under `docs/evidence/screenshots/` for:

- AWS Budget showing the configured limit.
- EC2 instance `cloud-ecommerce-dev-app` running.
- EC2 details showing instance type and 30 GB encrypted root volume.
- RDS instance `cloud-ecommerce-dev-postgres` available.
- RDS connectivity/security showing it is not publicly accessible.
- SQS queue `cloud-ecommerce-dev-order-created`.
- SQS DLQ `cloud-ecommerce-dev-order-created-dlq`.
- SQS queue attributes showing the redrive policy.
- S3 bucket used for Terraform remote state.
- DynamoDB table used for Terraform locking.
- GitHub Actions CI successful run.
- Terraform validation and outputs.
- API health checks for ports `8081`, `8082`, and `8083`.
- Product creation response.
- Order creation response.
- SQS and DLQ attributes showing zero messages after processing.

Terminal/API outputs are documented in `docs/evidence.md`.

## Commands To Save

Run these and save the output in the delivery evidence:

```bash
terraform -chdir=infra/envs/dev validate
terraform -chdir=infra/envs/dev output
```

```bash
curl http://108.130.209.64:8081/actuator/health
curl http://108.130.209.64:8082/actuator/health
curl http://108.130.209.64:8083/actuator/health
```

```bash
curl http://108.130.209.64:8081/products
curl http://108.130.209.64:8082/orders
```

```bash
aws sqs get-queue-attributes \
  --queue-url https://sqs.eu-west-1.amazonaws.com/337058962986/cloud-ecommerce-dev-order-created \
  --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible ApproximateNumberOfMessagesDelayed
```

```bash
aws sqs get-queue-attributes \
  --queue-url https://sqs.eu-west-1.amazonaws.com/337058962986/cloud-ecommerce-dev-order-created-dlq \
  --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible ApproximateNumberOfMessagesDelayed
```

## Known Delivery Notes

- The original EC2 private key is not available locally.
- Notification logs could not be retrieved from the existing EC2 instance.
- SQS and DLQ queue depth were used as evidence that the event was consumed
  successfully.
- GitHub Actions CI is working.
- The deploy workflow exists, but AWS OIDC/deploy credentials still need final
  configuration for fully automated deployment.

## Repository Safety

- No `.pem` files committed.
- No `terraform.tfvars` committed.
- No access keys committed.
- No database password committed.
- SSH CIDR is restricted.
- RDS is not public.

## Documentation To Review

- README is up to date.
- `docs/setup.md` explains the initial setup.
- `docs/deployment.md` explains deployment.
- `docs/architecture.md` explains the architecture.
- `docs/demo.md` contains the demo script.
- `docs/security.md` explains security decisions.
- `docs/limitations.md` documents known limitations.
- `docs/evidence.md` contains validation evidence.

## After Evaluation

- Run `terraform destroy`.
- Confirm EC2 and RDS are gone.
- Confirm no unexpected resources are still billing.
