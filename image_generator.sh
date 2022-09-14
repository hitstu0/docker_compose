#!/bin/bash
echo "begin generate image, depository is: $1, file is: $2,  port is: $3";

#基础镜像名格式：'仓库/文件夹', 该镜像包含不含有配置文件的jar包
BaseImageName=$(echo "$1/$2" | tr 'A-Z' 'a-z')
echo "base image name is: ${BaseImageName}"
#判断是否有该基础镜像
CON=`docker image ls '${BaseImageName}' | wc -l`
echo "con is ${CON}"

if [$CON == 2]
then
   #如果存在则以该镜像为基础修改配置 
   echo "base image exist, begin change setting"
   source change_setting.sh $1 $2 $3
else
   #不存在则先生成镜像再修改配置
   echo "base image not exist, begin build base"
   source generate_base.sh $1 $2 

   echo "build base success, begin change setting"
   cd /root/docker_compose
   source change_setting.sh $1 $2 $3
fi



