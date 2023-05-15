#!/bin/bash
echo "begin generate image, depository is: $1, file is: $2, version is: $3";

#根据[仓库名][文件名][版本]生成下载jar包生成下载连接
downloadUrl="https://github.com/hitstu0/$1/releases/download/$2-$3/$2-$3.jar";
echo "downloadUrl is: ${downloadUrl}"

mkdir $2-$3
cd $2-$3

wget downloadUrl
#由jar包生成镜像
echo "FROM openjdk:8-jdk-alpine
COPY $2-$3.jar app.jar
ENTRYPOINT [\"java\", \"-jar\", \"app.jar\"]" >> Dockerfile

imageName=$(echo "$2" | tr 'A-Z' 'a-z') 

echo "begin build image, name is ${imageName}"
docker build -t ${imageName} .

#删除临时文件
cd ..
rm -rf $2-$3





