#!/bin/sh
echo "begin adjust container:$1 to num: $2"
image_name=$1

new_nums=$2
if [ $new_nums -lt 0 ]
then
   new_nums=0
fi

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

       containerId=$(docker run -d -l SERVICE_tags=apihost=$3,apiport=$4,weight=1 -p ${port}:${port} -v /root/logs/${image_name}/${port}:/logs  --name="${image_name}_${port}" ${image_name}\
       java -jar app.jar --logging.path=./logs --spring.cloud.consul.host=$3 --spring.cloud.consul.port=8500 --server.port=${port} --spring.cloud.consul.discovery.instance-id=${image_name})
       echo "container start success, id is ${containerId}"


