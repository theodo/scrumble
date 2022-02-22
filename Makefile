migration-create:
	docker-compose run --rm api \
	./node_modules/db-migrate/bin/db-migrate create --config migrations/database.json $(name)

migration-up:
	docker-compose run --rm api \
	./node_modules/db-migrate/bin/db-migrate up --config migrations/database.json

migration-down:
	docker-compose run --rm api \
	./node_modules/db-migrate/bin/db-migrate down --config migrations/database.json

install:
	cd client && npm ci --ignore-scripts

start:
	docker-compose up -d
	cd client && npm start
