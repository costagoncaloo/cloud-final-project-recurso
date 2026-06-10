# Demo Script

## Local

```bash
make up
make demo-order
make logs
```

Expected result:

- `catalog-service` stores a product.
- `order-service` stores an order and publishes an SQS message.
- `notification-service` logs that it processed the notification.

Useful endpoints:

- `GET http://localhost:8081/products`
- `POST http://localhost:8081/products`
- `GET http://localhost:8082/orders`
- `POST http://localhost:8082/orders`
- `GET http://localhost:8081/actuator/health`
- `GET http://localhost:8082/actuator/health`
- `GET http://localhost:8083/actuator/health`

## AWS

After Terraform and Ansible:

```bash
terraform -chdir=infra/envs/dev output
curl http://APP_PUBLIC_IP:8081/actuator/health
curl http://APP_PUBLIC_IP:8082/actuator/health
curl http://APP_PUBLIC_IP:8083/actuator/health
```

Then create a product and an order against the EC2 public IP.
