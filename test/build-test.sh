#!/bin/sh

IMAGE_NAME=liquibase-docker
docker build  -t $IMAGE_NAME .

docker-compose -f ./test/docker-compose-test.yml up
