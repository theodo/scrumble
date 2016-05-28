provisioning:
	ansible-playbook devops/provisioning.yml -i devops/hosts/production

whoami := $(shell whoami)
migration-create:
	docker-compose run --rm api \
	./node_modules/db-migrate/bin/db-migrate create --config migrations/database.json $(name)\
	 && sudo chown -R ${whoami}:${whoami} api/migrations
migration-up:
	docker-compose run --rm api ./node_modules/db-migrate/bin/db-migrate up --config migrations/database.json
migration-down:
	docker-compose run --rm api ./node_modules/db-migrate/bin/db-migrate down --config migrations/database.json

install:
	docker-compose run --rm api npm install && \
	sudo chown -R ${whoami}:${whoami} api/node_modules && \
	ansible-galaxy install --force -r devops/requirements.yml -p devops/roles
npm-install:
	docker-compose run --rm api \
	npm install --save-exact --save $(package) &&\
	sudo chown ${whoami}:${whoami} package.json &&\
	sudo chown -R ${whoami}:${whoami} api/node_modules

start:
	docker-compose up api
run-test:
	docker-compose -f docker-compose.test.yml run --rm apitest && \
	npm test

api-build:
	docker build -t nicgirault/scrumble-api api
api-push:
	docker push nicgirault/scrumble-api

client-install:
	docker-compose --file docker-compose.dev.yml run --rm app npm install --unsafe-perm && \
	sudo chown -R ${whoami}:${whoami} ./client/node_modules && \
	sudo chown -R ${whoami}:${whoami} ./client/bower_components
client-start:
	docker-compose --file docker-compose.dev.yml up app
client-build:
	docker-compose --file docker-compose.dev.yml up appbuilder && \
	docker build -t nicgirault/scrumble client

client-push:
	docker push nicgirault/scrumble

showcase-build:
	docker build -t nicgirault/scrumble-showcase showcase

showcase-push:
	docker push nicgirault/scrumble-showcase

deploy:
	eval "$(docker-machine env prod)" && \
	docker-compose --file docker-compose.prod.yml up -d && \
	eval "$(docker-machine env -u)"

create-host:
	docker-machine create \
	  --driver generic \
	  --generic-ip-address=${remoteip} \
		--generic-ssh-user=dockeradmin \
	  --generic-ssh-key ~/.ssh/id_rsa \
	  prod
