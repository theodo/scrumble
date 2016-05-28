# Scrumble [![Circle CI](https://circleci.com/gh/theodo/scrumble.svg?style=svg)](https://circleci.com/gh/theodo/scrumble)

[Scrumble](https://theodo.github.io/scrumble/) is an app we use at Theodo Academy to perform faster daily Scrum tasks:

It is connected to your Trello board and GoogleApps account and helps to:
- Update your burndown chart
- Send daily reports to your client ([what is a daily report?](http://www.theodo.fr/blog/2015/10/you-want-to-do-scrum-start-with-daily-reports/))
- Fill Satisfaction survey

## Installation

I use docker, docker-compose for dev environment and docker-machine to deploy.
All the commands are in the Makefile. You should read this file.

```
git clone git@github.com:theodo/scrumble.git
make install
make client-start
make api-start
```
