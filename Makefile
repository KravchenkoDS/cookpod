.PHONY: start migrate server default credo format test

default: format credo test

start: migrate server

migrate:
	mix ecto.migrate

server:
	mix phx.server

credo:
	mix credo --strict

format:
	mix format

test:
	mix coveralls

build:
	docker build -t cookpod:latest .

prod:
	docker run --rm \
		-e COOKPOD_HOST=localhost  \
		-e PORT=4000  \
		-e SECRET_KEY_BASE=+Y0dQezR7SDPae0DuQrQEQZUFXSIhnfkKPtMe+g+1uEVzx3SKjegZG5e+LxEvoUV \
		-e DB_NAME=cookpod_dev \
		-e DB_USERNAME=postgres \
		-e DB_PASSWORD=postgres \
		-e DB_HOSTNAME=docker.localhost  \
		-p 127.0.0.1:4000:4000/tcp \
		cookpod	