#!/bin/sh
image_name=$1
theIP="120.78.165.96"


       #查询可用端口
       port=0
       while [ $port -eq 0 ]
       do
           ran=$(($RANDOM + 100000))
           result=$((ran%64511 + 1024))
           echo "random port is: ${result}"

           portNums=$(netstat -anp | grep $result | wc -l)
           if [ $portNums -eq 0 ] 
           then
               port=$result
           fi
       done
       echo "get available port $port"

       #启动新容器
       javaopt="-Xms=50m -Xmx=200m"

       containerId=$(docker run -d -p ${port}:${port} -v /root/logs:/root/logs  --name="${image_name}_${port}" ${image_name}\
       java -jar ${javaopt} app.jar  --logging.path=./logs --spring.cloud.consul.host=${theIP} --spring.cloud.consul.port=8500 --server.port=${port} --spring.cloud.consul.discovery.instance-id=${image_name})
       echo "container start success, id is ${containerId}"


