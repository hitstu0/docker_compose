#!/bin/bash
echo "begin generate image, depository is: $1, file is: $2";

#基础镜像名格式：'仓库/文件夹', 该镜像包含不含有配置文件的jar包
BaseImageName=$(echo "$1/$2" | tr 'A-Z' 'a-z')
echo "base image name is: ${BaseImageName}"

#判断是否有该基础镜像
CON=$(docker image ls "${BaseImageName}" | wc -l)
echo "count is ${CON}"

if [ $CON != 2 ]
then
   #如果不存在则生基础镜像
   echo "begin generate base image, depository is: $1, file is: $2";

#根据仓库名生成git url
gitPre="https://github.com/hitstu0";
gitUrl="${gitPre}/${1}.git"

echo "gitUrl is: ${gitUrl}"

#创建临时文件
cd /root
fileName="gitcode_$1_$2"
mkdir ${fileName}
cd ${fileName}
echo "make file success, file is $(pwd)"

#git clone 并生成jar包
git init
git remote add -f origin ${gitUrl}
git config core.sparseCheckout true
echo "$2/target/$2.jar" >> .git/info/sparse-checkout
git pull origin master
cd $2

#由jar包生成镜像
echo "FROM openjdk:8-jdk-alpine
COPY target/*.jar app.jar
ENTRYPOINT [\"java\", \"-jar\", \"app.jar\"]" >>Dockerfile

imageName=$(echo "$2" | tr 'A-Z' 'a-z') 

echo "begin build image, name is ${imageName}"
docker build -t ${imageName} .

#删除临时文件
cd ../..
rm -rf "gitcode_$1_$2"

cd $3/docker_compose
fi



