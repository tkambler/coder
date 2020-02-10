.PHONY: build build-node build-python build-go run run-official push

build:
	docker-compose build

build-node:
	docker-compose build node

build-python:
	docker-compose build python

build-go:
	docker-compose build go

run:
	docker run -it -p 127.0.0.1:8080:8080 -v "$$PWD:/home/coder/project" coder-tmp:latest

run-official:
	docker run -it -p 127.0.0.1:8080:8080 -v "$$PWD:/home/coder/project" codercom/code-server

push:
	docker-compose push
