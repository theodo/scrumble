# Scrumble [![Circle CI](https://circleci.com/gh/theodo/scrumble.svg?style=svg)](https://circleci.com/gh/theodo/scrumble)

[Scrumble](https://theodo.github.io/scrumble/) is an app we use at M33 to perform faster daily Scrum tasks:

It is connected to your Trello board and GoogleApps account and helps to:
- Update your burndown chart
- Send daily reports to your client ([what is a daily report?](http://www.theodo.fr/blog/2015/10/you-want-to-do-scrum-start-with-daily-reports/))
- Fill Satisfaction survey
- Track your problems and actions


## Installation

**Requisites**

The easiest way to develop on Scrumble is to:
- [install docker](https://docs.docker.com/engine/installation/)
- [make sure your user is part of the docker group](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo)
to avoid running all commands as root (read the optional configuration).
- [install docker-compose](https://docs.docker.com/compose/install/)
- [install docker-machine](https://docs.docker.com/machine/install-machine/)

Make sure your Docker installation is working fine by typing `docker ps`. Under Mac OS X you may have to [run some commands](https://docs.docker.com/engine/installation/linux/ubuntulinux/#create-a-docker-group) after installing to get Docker working in your shell.

**Clone the Project**

```
git clone git@github.com:theodo/scrumble.git && cd scrumble
```
For Mac OS X users, the project folder must be in a subfolder of /Users, due to [an issue in docker-machine](https://github.com/docker/machine/issues/13).

**Specify environment variables in docker-compose.dev.yml**

```
 cp docker-compose.dev.yml.dist docker-compose.dev.yml
```
**Launch the installation**

```
make install
```

**Launch the project**

```
make start
```


## Provisioning

```
sudo adduser dockeradmin && sudo groupadd docker && sudo gpasswd -a dockeradmin docker

sudo cp -R ~/.ssh /home/dockeradmin && sudo chown -R dockeradmin:dockeradmin /home/dockeradmin/.ssh
```

## Develop

There are many commands in the makefile that are self comprehensible. Please,
read the makefile.

In order to connect to the app on your machine, you'll need to have a Trello key:
- Go to the [Trello developer key generator](https://trello.com/app-key)
- Get your public key (top of the page) and:
  - copy it in `docker-compose.dev.yml`
  - copy it in `client/src/app.coffee` in the `TrelloClientProvider.init` parameters
  - copy it in `client/src/login/config/trello.coffee`
- Get your secret key (bottom of the page) and copy it in `docker-compose.dev.yml`


## Deploy

Create the docker-machine remote host `make create-host remoteip=xxx.xxx.xxx.xxx`.

Build&push all docker images from local and pull them from remote: `make build-deploy-all`.


## Setup database backup on server

The email will probably arrive in the spam folder.

```
apt install mutt
DB_USER=xxx
DB_NAME=xxx
DB_CONTAINER=xxx
TO=xxx
echo "FILENAME=dump_\`date +%d-%m-%Y"_"%H_%M_%S\`.sql
docker exec $DB_CONTAINER pg_dump --username=$DB_USER $DB_NAME > \$FILENAME
echo \"You'll find attached the Scrumble backup\" | mutt -a \$FILENAME -s \"Scrumble Backup\" -- $TO
rm \$FILENAME" >> backup.sh
chmod +x backup.sh

echo "0 0 * * * ~/backup.sh" >> /var/spool/cron/crontabs/root
```

## Renew Let's Encrypt certificates

If the HTTPS certificates expire, follow these steps:
- Deploy the application again
- See the [docker-letsencrypt-nginx-proxy-companion doc](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion).
- Check the status (it should be renewed)
- if not force renewal

## Space issue on server

`docker rmi $(docker images -f "dangling=true" -q)`
