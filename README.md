# Scrumble [![Circle CI](https://circleci.com/gh/theodo/scrumble.svg?style=svg)](https://circleci.com/gh/theodo/scrumble)

[Scrumble](https://theodo.github.io/scrumble/) is an app we use at Theodo Academy to perform faster daily Scrum tasks:

It is connected to your Trello board and GoogleApps account and helps to:
- Update your burndown chart
- Send daily reports to your client ([what is a daily report?](http://www.theodo.fr/blog/2015/10/you-want-to-do-scrum-start-with-daily-reports/))
- Fill Satisfaction survey

## Installation

The easiest way to develop on Scrumble is to install:
- [docker](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [docker-machine](https://docs.docker.com/machine/install-machine/)

Make sure your Docker installation is working fine by typing `docker ps`. Under Mac OS X you may have to [run some commands](https://docs.docker.com/engine/installation/mac/) after installing to get Docker working in your shell.

[Make sure your user is part of the docker group](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo)
to avoid running all commands as root.

For Mac OS X users, the project folder must be in a subfolder of /Users, due to [an issue in docker-machine](https://github.com/docker/machine/issues/13).

```
git clone git@github.com:theodo/scrumble.git && cd scrumble
cp docker-compose.dev.yml.dist docker-compose.dev.yml
```

**Specify environment variables in docker-compose.dev.yml**

```
make install
make start
```

## Deploy

Create the docker-machine remote host `make create-host remoteip=xxx.xxx.xxx.xxx`.

Build&push all docker images from local and pull them from remote: `make build-deploy-all`.

## Develop

There are many commands in the makefile that are self comprehensible. Please,
read the makefile.


Top 3 priorités :
- Une 500 ne fait pas tomber le serveur
- Le formulaire est sauvegardé dans une google spreadsheet (feedbacks aussi)
- Les pings sont fait sur loopback
- Directive pour bouton en cours d'action
