provisioning:
	ansible-playbook devops/provisioning.yml -i devops/hosts/production

whoami := $(shell whoami)
migration-create:
	docker-compose run --rm api \
	./node_modules/db-migrate/bin/db-migrate create --config migrations/database.json $(name)\
	 && sudo chown -R ${whoami}:${whoami} migrations
migration-up:
	docker-compose run --rm api ./node_modules/db-migrate/bin/db-migrate up --config migrations/database.json
migration-down:
	docker-compose run --rm api ./node_modules/db-migrate/bin/db-migrate down --config migrations/database.json

install:
	docker-compose run --rm api npm install && \
	sudo chown -R ${whoami}:${whoami} node_modules && \
	ansible-galaxy install --force -r devops/requirements.yml -p devops/roles
npm-install:
	docker-compose run --rm api \
	npm install --save-exact --save $(package)\
	&& sudo chown ${whoami}:${whoami} package.json\
	&& sudo chown -R ${whoami}:${whoami} node_modules

start:
	docker-compose up api
run-test:
	docker-compose -f docker-compose.test.yml run --rm apitest \
	npm test

build:
	docker build -t nicgirault/scrumble-api .
push: build
	docker push nicgirault/scrumble-api
deploy: push
	ansible-playbook -i devops/hosts/production devops/deploy.yml
