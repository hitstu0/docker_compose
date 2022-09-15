#!/bin/bash
echo "begin change setting, depository is: $1, file is: $2, port is: $3";

#创建临时文件
cd /root
fileName="cs_$1_$2_$3"
mkdir ${fileName}
cd ${fileName}
echo "make file success, file is $(pwd)"

BaseImageName=$(echo "$1/$2" | tr 'A-Z' 'a-z') 
#添加启动命令
arg1="java"
arg2="-jar"
arg3="app.jar"
arg4="--server.port=$3"
arg5="--spring.cloud.consul.discovery.instance-id=$1-$2-$3"
arg6="--spring.cloud.consul.host=120.77.221.92"
arg7="--spring.cloud.consul.port=8500"
echo "FROM ${BaseImageName}
ENTRYPOINT [\"${arg1}\", \"${arg2}\", \"${arg3}\", \"${arg4}\", \"${arg5}\", \"${arg6}\", \"${arg7}\"] " >> Dockerfile

#开始构建镜像
imageName=$(echo "$1/$2_$3" | tr 'A-Z' 'a-z') 
echo "begin build img, image name is:${imageName}"
docker build -t ${imageName} .

#清理工作
cd ..
rm -rf ${fileName}
