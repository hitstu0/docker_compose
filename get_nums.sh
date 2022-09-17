#!/bin/sh

nums=$(docker ps --format {{.Image}} | grep $1 | wc -l)
echo "number is: ${nums}"