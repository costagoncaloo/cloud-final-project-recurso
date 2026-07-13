# Cloud E-Commerce Microservices

Base application for the Cloud Information Systems resit project.

At this stage the repository intentionally contains only the local microservices
application. Cloud infrastructure, deployment automation, CI/CD and delivery
documentation will be rebuilt step by step for the new individual project setup.

## Services

- `catalog-service`: product REST API backed by PostgreSQL.
- `order-service`: order REST API backed by PostgreSQL.
- `notification-service`: notification API used as a placeholder for future
  service communication work.

## Local Architecture

- Docker Compose starts the three services.
- PostgreSQL is used for catalog and order persistence.
- Cloud infrastructure and asynchronous communication will be rebuilt from
  scratch as part of the resit project.

## Quick Local Run

Start the stack:

```bash
make up
```

Create a demo product and order:

```bash
make demo-order
```

Follow service logs:

```bash
make logs
```

Stop the stack:

```bash
make down
```

## Useful Endpoints

- `GET http://localhost:8081/products`
- `POST http://localhost:8081/products`
- `GET http://localhost:8082/orders`
- `POST http://localhost:8082/orders`
- `GET http://localhost:8081/actuator/health`
- `GET http://localhost:8082/actuator/health`
- `GET http://localhost:8083/actuator/health`

## Tests

Run all service tests:

```bash
make test
```
