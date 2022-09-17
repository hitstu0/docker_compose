#!/bin/bash
echo "begin generate image, depository is: $1, file is: $2";

#基础镜像名格式：'仓库/文件夹', 该镜像包含不含有配置文件的jar包
BaseImageName=$(echo "$1/$2" | tr 'A-Z' 'a-z')
echo "base image name is: ${BaseImageName}"

#判断是否有该基础镜像
CON=`docker image ls "${BaseImageName}" | wc -l`
echo "count is ${CON}"

if [ $CON != 2 ]
then
   #如果不存在则生基础镜像
   echo "base image not exist, begin generate image"
   source generate_base.sh $1 $2 
fi



