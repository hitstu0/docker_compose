#!/bin/sh
id=$(docker ps -a)
docker stop ${id}
docker rm ${id}