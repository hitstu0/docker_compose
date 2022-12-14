#!/bin/sh
echo "begin adjust container:$1 apiPort is : $2"
image_name=$1

theIP="120.78.165.96"

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

javaopt="-Xms64m -Xmx200m -Xss64m -XX:MaxDirectMemorySize=32m -XX:MaxMetaspaceSize=32m"

containerId=$(docker run -d -l SERVICE_tags=apihost=${theIP},apiport=$2,weight=1 -p ${port}:${port} -p 7000:7000 -v /root/logs/${image_name}/${port}:/logs  --name="${image_name}_${port}" ${image_name} \
java -jar ${javaopt} app.jar --spring.cloud.consul.host=${theIP} --spring.cloud.consul.port=8500 --server.port=${port} --spring.cloud.consul.discovery.instance-id=${image_name})
echo "container start success, id is ${containerId}"


