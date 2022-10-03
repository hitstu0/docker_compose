#!/bin/sh
echo "begin adjust container:$1 to num: $2"
image_name=$1

new_nums=$2
if [ $new_nums -lt 0 ]
then
   new_nums=0
fi

#查询当前容器数
old_nums=$(docker ps --format {{.Image}} | grep ${image_name} | wc -l)
echo "now number is: ${old_nums}"

if [ $new_nums -gt $old_nums ]
then
   echo "begin to expansion"

   while [ $old_nums -lt $new_nums ]
   do
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

       containerId=$(docker run -d -l SERVICE_tags=apihost=120.77.221.92,apiport=${port},weight=3 -p ${port}:${port} -v /logs/${image_name}/${port}:/log  --name="${image_name}_${port}" ${image_name}\
       java -jar app.jar --spring.cloud.consul.host=120.77.221.92 --spring.cloud.consul.port=8500 --server.port=${port} --spring.cloud.consul.discovery.instance-id=${image_name})
       echo "container start success, id is ${containerId}"

       old_nums=$((old_nums + 1))
   done

elif [ $new_nums -lt $old_nums ]
then
   echo "begin to shrink"

   while [ $old_nums -gt $new_nums ] 
   do
      #查询容器id
      deleId=$(docker ps | grep $1 | awk '{print$1}' | sed -n '1p')

      #停止并删除容器
      docker stop $deleId
      docker rm $deleId
      old_nums=$((old_nums - 1))
   done
 
else 
   echo "number not change, not need to adjust"
fi

#删除旧nginx配置
#rm -rf nginx/tlocation/${image_name}.conf
#rm -rf nginx/tupstream/${image_name}.conf

#if [ $new_nums != 0 ]
#then
   #生成upstream
 #  servers=$(docker ps --format "{{.Image}} {{.Names}}" | grep ${image_name} | awk '{print"server "$2":"substr($2,2)";"}')
  #upstream="upstream ${image_name} {
   #   ${servers}
   #}"
   #echo "${upstream}" >> nginx/tupstream/${image_name}.conf

   #生成localtion代码
   #location="location /${image_name} {
     # proxy_pass http://${image_name};
  # }"
   #echo "${location}" >> nginx/tlocation/${image_name}.conf

   #重启nginx
   #docker stop nginx
   #cd nginx
   #docker-compose up
#fi


