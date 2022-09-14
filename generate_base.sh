#!/bin/bash
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
git clone ${gitUrl}
cd "$1/$2"
"./mvnw" package -f "./pom.xml"

#由jar包生成镜像
echo "FROM openjdk:8-jdk-alpine
COPY target/*.jar app.jar
ENTRYPOINT [\"java\", \"-jar\", \"app.jar\"]" >>Dockerfile

imageName=$(echo "$1/$2" | tr 'A-Z' 'a-z') 

echo "begin build image, name is ${imageName}"
docker build -t ${imageName} .

#删除临时文件
cd ../../..
rm -rf "gitcode_$1_$2"

