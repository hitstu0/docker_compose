#!/bin/sh
echo "begin generater api gateway for:$1"
IP="120.78.165.96"
#启动API网关
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

docker run -d -p ${port}:${port} -v /root/logs/api/${port}:/log --name="api_$1" api_gateway \
java -jar app.jar --spring.cloud.consul.host=${IP} --spring.cloud.consul.port=8500 --server.port=${port} --spring.cloud.consul.discovery.instance-id="api_$1"

curl ${IP}:$port/refresh

mport=0
while [ $mport -eq 0 ]
do
    ran=$(($RANDOM + 100000))
    result=$((ran%64511 + 1024))
    echo "random port is: ${result}"

    portNums=$(netstat -anp | grep $result | wc -l)
    if [ $portNums -eq 0 ] 
        then
            mport=$result
        fi
done
echo "get available port $mport"

containerId=$(docker run -d -l SERVICE_tags=apihost=${IP},apiport=${port},weight=3 -p ${mport}:${mport} -v /root/logs/$1/${mport}:/log  --name="$1_${mport}" $1 \
java -jar app.jar --spring.cloud.consul.host=${IP} --spring.cloud.consul.port=8500 --server.port=${mport} --spring.cloud.consul.discovery.instance-id=$1)
echo "container start success, id is ${containerId}"
