#!/bin/bash
echo "begin change setting, depository is: $1, file is: $2, port is: $3";

#创建临时文件
cd /root
fileName="cs_$1_$2_$3"
mkdir ${fileName}
cd ${fileName}
echo "make file success, file is $(pwd)"

BaseImageName=$(echo "$1/$2" | tr 'A-Z' 'a-z') 
#改变jar包配置
echo "FROM ${BaseImageName}
RUN mkdir -p BOOT-INF/classes \
echo \"server.port=$3 \\n spring.cloud.consul.discovery.instance-id=$1_$2_$3 \\n spring.cloud.consul.host=120.77.221.92 \\n spring.cloud.consul.port=8500 \" >> BOOT-INF/classes/application-auto.properties \ 
jar uf app.jar BOOT-INF/classes/application-auto.properties
ENTRYPOINT [\"java\", \"-jar\", \"app.jar\"] " >> Dockerfile

#开始构建镜像
imageName=$(echo "$1/$2_$3" | tr 'A-Z' 'a-z') 
echo "begin build img, image name is:${imageName}"
docker build -t ${imageName} .

#清理工作
cd ..
rm -rf ${fileName}
