#!/bin/bash

#安装docker和docker-compose
#curl -sSL https://get.daocloud.io/docker | sh
#curl -L https://get.daocloud.io/docker/compose/releases/download/v2.4.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
#安装git和maven
#sudo apt update
#sudo apt-get install git
#sudo apt install maven


#拉取脚本
git clone https://github.com/hitstu0/docker_compose.git
cd docker_compose

#配置环境变量
export IP=$1
echo "brokerIP1=$1" >> rmq/broker.conf

#启动基本组件
cd base_con
docker-compose up -d
cd ..

#启动日志
source image_generator.sh YC log_manager
source adjust_num.sh log_manager 1 $1


source image_generator.sh nginx_manager
source adjust_num.sh nginx_manager 1 $1

#启动四层负载均衡
cd nginx/four
docker-compose up -d
cd ../..

#启动七层负载均衡
cd nginx/seven
docker-compose up -d
cd ../..





