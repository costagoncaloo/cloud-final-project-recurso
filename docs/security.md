# Security Notes

- AWS credentials are not committed to the repository.
- GitHub Actions deployment should use OIDC through `AWS_ROLE_TO_ASSUME`.
- RDS is placed in private subnets and is not publicly accessible.
- PostgreSQL ingress is restricted to the application security group.
- SSH ingress is restricted by `allowed_ssh_cidr`; use your public IP with `/32`.
- The EC2 instance has an IAM instance role allowing only the SQS actions needed
  by the services.
- Terraform state must use an encrypted S3 bucket and DynamoDB locking.

Known improvement for a stronger defense:

- Move `db_password` from Terraform variables/user data into AWS Secrets Manager
  or SSM Parameter Store.
- Add image scanning in CI.
- Add CloudWatch log groups and alarms.
