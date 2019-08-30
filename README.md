# Hours - Docker Setup

First make sure docker is installed. 

## Setup Network

Clone and run traefik (this handles subdomain issues)
- `git clone https://github.com/nolo900/traefik_docker.git`
- `cd traefit_docker`
- `docker-compose up`

## Setup this project

clone repo, then once in project dir run
`docker-compose run --rm app rake db:create db:migrate`



