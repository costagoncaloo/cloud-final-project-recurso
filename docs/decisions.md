# Decisions

## Domain

Use a mini e-commerce backend because it matches the reference architecture and
keeps the business logic simple.

## Compute

Use one EC2 instance with Docker for the first version. This keeps the deployment
close to the course labs and lets Ansible demonstrate configuration management.

## Messaging

Use SQS for the order-created event. This gives a clear producer/consumer story
and supports retries and a DLQ.

## Database

Use PostgreSQL. Locally each stateful service has its own database container. In
AWS, the initial version uses one RDS PostgreSQL database shared by the services,
with separate tables and a documented trade-off. A later version could create
separate schemas or databases during deployment.
