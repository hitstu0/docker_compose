#!/bin/sh
image_name=$1
theIP=$2


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

#启动新容器
javaopt="-Xms=50m -Xmx=128m"

containerId=$(docker run -d -p ${port}:${port} -v /root/logs:/root/logs  --cap-add=SYS_PTRACE --name="${image_name}_${port}" ${image_name} \
java -jar ${javaopt} app.jar  --logging.path=./logs --spring.cloud.consul.host=${theIP} --spring.cloud.consul.port=8500 --server.port=${port} --spring.cloud.consul.discovery.instance-id=${image_name})
echo "container start success, id is ${containerId}"


