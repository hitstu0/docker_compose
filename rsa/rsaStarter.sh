#!/bin/sh
image_name=$1
theIP=$2
nginxIp=$3
nginxPort=$4

       #查询可用端口
       port=0
       while [ $port -eq 0 ]
       do
           ran=$(($RANDOM + 100000))
           result=$((ran%10 + 7000))
           echo "random port is: ${result}"

           portNums=$(netstat -anp | grep $result | wc -l)
           if [ $portNums -eq 0 ] 
           then
               port=$result
           fi
       done
       echo "get available port $port"
       export API_PORT=$port
       #启动新容器

       containerId=$(docker run -d  -p ${port}:${port} -v /root/logs/${image_name}/${port}:/log  --name="${image_name}_${port}" ${image_name}\
       java -jar app.jar --target_ip=$3 --target_port=$4 --spring.cloud.consul.host=${theIP} --spring.cloud.consul.port=8500 --server.port=${port} --spring.cloud.consul.discovery.instance-id=${image_name})
       echo "container start success, id is ${containerId}"