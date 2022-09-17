#!/bin/sh
echo "begin adjust container:$1 to num: $2"

#查询当前容器数
nums=$(docker ps --format {{.Image}} | grep $1 | wc -l)
echo "now number is: ${nums}"

if [ $2 == $nums]
then
   echo "number not change, not need to adjust"
fi

if [ $2 > $nums ]
then
   echo "begin to expansion"

   #查询可用端口
   while (($nums < $2))
   do
       port=-1
       while (($port == -1))
       do
           ran=`expr $random + 100000`
           result=`expr $ran%65535 + 1024`
           portNums=$(netstat -anp | grep $result | wc -l)
           if [ $portNums == 0 ] 
           then
               $port = $result
           fi
       done
       echo "get available port $port"

       #启动新容器
       containerName=${$1///_}
       containerId=$(docker run -d -p ${port}:${port} --name=${containerName}_${port}\
       java -jar app.jar --server.port=${port} --spring.cloud.consul.discovery.instance-id=${containerName}_${port})
       echo "container start success, id is ${containerId}"
       nums=`expr $nums + 1`
   done

else
   echo "begin to shrink"

fi


#--spring.cloud.consul.discovery.instance-id=%s_%d "
