whoami := $(shell whoami)

install:
	docker-compose --file docker-compose.dev.yml run --rm api npm install && \
	sudo chown -R ${whoami}:${whoami} api/node_modules && \
	docker-compose --file docker-compose.dev.yml run --rm appbuilder npm install --unsafe-perm && \
	sudo chown -R ${whoami}:${whoami} client/node_modules && \
	sudo chown -R ${whoami}:${whoami} client/bower_components

migration-create:
	docker-compose --file docker-compose.dev.yml run --rm api \
	./node_modules/db-migrate/bin/db-migrate create --config migrations/database.json $(name)\
	 && sudo chown -R ${whoami}:${whoami} api/migrations
migration-up:
	docker-compose --file docker-compose.dev.yml run --rm api \
	./node_modules/db-migrate/bin/db-migrate up --config migrations/database.json
migration-down:
	docker-compose --file docker-compose.dev.yml run --rm api \
	./node_modules/db-migrate/bin/db-migrate down --config migrations/database.json

npm-install:
	docker-compose run --rm api \
	npm install --save-exact --save $(package) &&\
	sudo chown ${whoami}:${whoami} package.json &&\
	sudo chown -R ${whoami}:${whoami} api/node_modules

run-test:
	docker-compose -f docker-compose.test.yml run --rm apitest && \
	npm test

api-build:
	docker build -t nicgirault/scrumble-api api
api-push:
	docker push nicgirault/scrumble-api

client-bower-install:
	docker-compose --file docker-compose.dev.yml run --rm appbuilder ./node_modules/.bin/bower install --save --allow-root ${package} && \
	sudo chown -R ${whoami}:${whoami} ./client/bower_components

start:
	docker-compose --file docker-compose.dev.yml up

client-build:
	docker-compose --file docker-compose.build.yml up appbuilder && \
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
