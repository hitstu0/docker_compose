#!/bin/bash
echo "starting run nginx from dynamic configuration"
echo "configuration server is $1, port is $2"

#请求自动生成的配置文件
echo "begin request configuration"

configuration=$(curl http://$1:$2/nginx_config/dynamic)
code=$(echo "${configuration}" | jq .code)
msg=$(echo "${configuration}" | jq --raw-output .msg)

if [ $code != 0 ] 
then
    echo "request configuration fail, code is ${code}, msg is ${msg}"
else  
    echo "request configuration success, config is ${msg}"
    
    #请求成功则生成配置文件并重启nginx
    echo "${msg}" >> nginx/dynamic/nginx.conf
    echo "write nginx conf success"
    
    #docker stop nginx
    cd nginx
    docker-compose up -d
fi


