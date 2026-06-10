COMPOSE=docker compose

.PHONY: up down logs test build demo-order

up:
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f catalog-service order-service notification-service

test:
	cd services/catalog-service && ./mvnw test
	cd services/order-service && ./mvnw test
	cd services/notification-service && ./mvnw test

build:
	$(COMPOSE) build

demo-order:
	curl -s -X POST http://localhost:8081/products \
	  -H 'Content-Type: application/json' \
	  -d '{"name":"Keyboard","description":"Mechanical keyboard","price":79.99,"stock":10}'
	curl -s -X POST http://localhost:8082/orders \
	  -H 'Content-Type: application/json' \
	  -d '{"productId":1,"quantity":2}'
