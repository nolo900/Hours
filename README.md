# Hours - Docker Setup

First make sure docker is installed. 

## Setup Network

Clone and run traefik, its a small docker container that handles local domain name routing
- `git clone https://github.com/nolo900/traefik_docker.git`
- `cd traefit_docker`
- `docker network create dev`
- `docker-compose up`

## Setup this project

clone repo this repo, then..
- `cd Hours`
- `docker-compose build`
- `docker-compose run --rm app rake db:create`
- `docker-compose run --rm app rake db:migrate`
- `docker-compose up`
