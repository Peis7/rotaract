EXEC_PHP = docker exec -it laravel_app
EXEC_NODE = docker exec -it node_build

.DEFAULT_GOAL := help

help:
	@echo "Available commands:"
	@echo " make build        - Build all Docker images"
	@echo " make up           - Start containers"
	@echo " make down         - Stop containers"
	@echo " make restart      - Restart containers"
	@echo " make composer     - Run composer install"
	@echo " make artisan CMD= - Run artisan command (e.g. make artisan CMD=migrate)"
	@echo " make node         - Run npm install + dev"
	@echo " make keygen       - Generate Laravel key"
	@echo " make logs         - Show app logs"
	@echo " make init         - Full init (Laravel key + migrate + npm dev)"

build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

restart: down up

composer:
	$(EXEC_PHP) composer install

artisan:
	$(EXEC_PHP) php artisan $(CMD)

keygen:
	$(EXEC_PHP) php artisan key:generate
	
migrate:
	docker exec -it laravel_app php artisan migrate

node:
	$(EXEC_NODE) npm install && npm run dev

logs:
	docker-compose logs -f

init: keygen artisan CMD=migrate node
