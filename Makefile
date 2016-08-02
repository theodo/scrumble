whoami := $(shell whoami)

install:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.dev.yml run --rm api npm install --quiet && \
	sudo chown -R ${whoami}:${whoami} api/node_modules && \
	docker-compose --file docker-compose.build.yml run --rm appbuilder npm install --quiet --unsafe-perm && \
	sudo chown -R ${whoami}:${whoami} client/node_modules && \
	sudo chown -R ${whoami}:${whoami} client/bower_components

migration-create:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.dev.yml run --rm api \
	./node_modules/db-migrate/bin/db-migrate create --config migrations/database.json $(name)\
	 && sudo chown -R ${whoami}:${whoami} api/migrations
migration-up:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.dev.yml run --rm api \
	./node_modules/db-migrate/bin/db-migrate up --config migrations/database.json
migration-down:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.dev.yml run --rm api \
	./node_modules/db-migrate/bin/db-migrate down --config migrations/database.json

npm-install:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.dev.yml run --rm api \
	npm install --save-exact --save $(package) &&\
	sudo chown ${whoami}:${whoami} api/package.json &&\
	sudo chown -R ${whoami}:${whoami} api/node_modules

api-test:
	eval "$$(docker-machine env -u)" && \
	docker-compose -f docker-compose.test.yml run --rm apitest

api-build:
	eval "$$(docker-machine env -u)" && \
	docker build -t nicgirault/scrumble-api api
api-push:
	eval "$$(docker-machine env -u)" && \
	docker push nicgirault/scrumble-api

client-npm-install:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.build.yml run --rm appbuilder npm install --save-dev  ${package} && \
	sudo chown -R ${whoami}:${whoami} ./client/node_modules && \
	sudo chown -R ${whoami}:${whoami} ./client/package.json

client-bower-install:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.build.yml run --rm appbuilder ./node_modules/.bin/bower install --save --allow-root ${package} && \
	sudo chown -R ${whoami}:${whoami} ./client/bower_components

start:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.dev.yml up

client-test:
	eval "$$(docker-machine env -u)" && \
	docker-compose -f docker-compose.test.yml run --rm apptest

client-test-tdd:
	eval "$$(docker-machine env -u)" && \
	docker-compose -f docker-compose.test.yml run --rm apptest npm run tdd

client-build:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.build.yml up appbuilder && \
	docker build -t nicgirault/scrumble client

client-push:
	eval "$$(docker-machine env -u)" && \
	docker push nicgirault/scrumble

client-deploy: client-build
	eval "$$(docker-machine env -u)" && \
	docker push nicgirault/scrumble && \
	eval "$$(docker-machine env prod)" && \
	docker-compose --file docker-compose.prod.yml pull && \
	docker-compose --file docker-compose.prod.yml up -d && \
	eval "$$(docker-machine env -u)"

showcase-build:
	eval "$$(docker-machine env -u)" && \
	docker build -t nicgirault/scrumble-showcase showcase
showcase-push:
	eval "$$(docker-machine env -u)" && \
	docker push nicgirault/scrumble-showcase

deploy:
	eval "$$(docker-machine env prod)" && \
	docker-compose --file docker-compose.prod.yml pull && \
	docker-compose --file docker-compose.prod.yml up -d

build: client-build showcase-build api-build
push: client-push showcase-push api-push

build-deploy-all:
	eval "$$(docker-machine env -u)" && \
	make build && \
	make push && \
	make deploy

create-host:
	docker-machine create \
	  --driver generic \
	  --generic-ip-address=${remoteip} \
		--generic-ssh-user=dockeradmin \
	  --generic-ssh-key ~/.ssh/id_rsa \
	  prod
