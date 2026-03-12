# Makefile - convenience targets for development and production

.PHONY: build run dev-up dev-down prod-up prod-down logs

.PHONY: migrate

build:
	go build -o votacao .

run: build
	./votacao

dev-up:
	docker compose -f docker-compose.yml up --build

dev-down:
	docker compose -f docker-compose.yml down

prod-up:
	# Copy .env.prod.example -> .env.prod and edit before running
	docker compose --env-file .env.prod -f docker-compose.prod.yml up --build

prod-down:
	docker compose -f docker-compose.prod.yml down

logs:
	docker compose -f docker-compose.prod.yml logs -f app

migrate:
	@echo "Applying SQL migrations from migrations/*.sql"
	@for f in migrations/*.sql; do \
		echo " -> $$f"; \
		docker compose exec -T db psql -U postgres -d moviesdb < $$f || exit 1; \
	done
