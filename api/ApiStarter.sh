#!/bin/sh
image_name=api_manager
theIP=120.78.165.96

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

       containerId=$(docker run -d  -p ${port}:${port} -v /root/logs/${image_name}/${port}:/logs  --name="${image_name}_${port}" ${image_name}\
       java -jar -Xms32m -Xmx128m -Xss32m -XX:MaxDirectMemorySize=32m -XX:MaxMetaspaceSize=32m app.jar --service_name=$1 --spring.cloud.consul.host=${theIP} --spring.cloud.consul.port=8500 --server.port=${port} --spring.cloud.consul.discovery.instance-id=${image_name})
       echo "container start success, id is ${containerId}"
