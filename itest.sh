#!/bin/bash

:<<!
#安装curl
apt-get update -y && apt-get install curl -y
#安装docker和docker-compose
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
docker -v

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

sudo service docker start
#安装git和maven
apt-get install git
apt-get install maven
!

#拉取脚本
git clone https://github.com/hitstu0/docker_compose.git
cd docker_compose

#启动基本组件
cd base_con
docker-compose up -d
cd ..


