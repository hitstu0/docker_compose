#!/bin/sh
echo "begin adjust container:$1 to num: $2"

#查询当前容器数
new_nums=$2
old_nums=$(docker ps --format {{.Image}} | grep $1 | wc -l)
echo "now number is: ${old_nums}"

if [ $new_nums -eq $old_nums ]
then
    echo "number not change, not need to adjust"
    exit
fi

if [ $new_nums -gt $old_nums ]
then
   echo "begin to expansion"

   #查询可用端口
   while [ $old_nums < $new_nums ]
   do
       port=-1
       while [ $port = -1 ]
       do
           ran=$(expr $random + 100000)
           result=$(expr $ran%65535 + 1024)
           portNums=$(netstat -anp | grep $result | wc -l)
           if [ $portNums == 0 ] 
           then
               port=$result
           fi
       done
       echo "get available port $port"

       #启动新容器
       containerName=$(sed 's/\//_/' $1)
       containerId=$(docker run -d -p ${port}:${port} --name=${containerName}_${port}\
       java -jar app.jar --server.port=${port} --spring.cloud.consul.discovery.instance-id=${containerName}_${port})
       echo "container start success, id is ${containerId}"
       old_nums= $(expr $old_nums + 1)
   done

else
   echo "begin to shrink"

fi


#--spring.cloud.consul.discovery.instance-id=%s_%d "
