# Makefile - convenience targets for development and production

.PHONY: build run dev-up dev-down prod-up prod-down logs

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
