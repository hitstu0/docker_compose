#!/bin/sh
id=$(docker ps -a | awk '{print $1}')
docker stop ${id}
docker rm ${id}