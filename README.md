# docker-in-docker

#### 介绍
docker-in-docker 扩展

#### 官方文档：
https://hub.docker.com/_/docker
https://docs.gitlab.com/ee/ci/docker/using_docker_build.html
https://about.gitlab.com/releases/2019/07/31/docker-in-docker-with-docker-19-dot-03/


#### 常规使用

##### 1、创建证书目录
mkdir /docker
mkdir /docker/certs
mkdir /docker/certs/ca
mkdir /docker/certs/client

##### 2、创建网络
docker network create docker-dind-network

##### 3、创建docker-daemon
docker run --privileged --name docker-dind -d \
    --network docker-dind-network --network-alias docker \
    -e DOCKER_TLS_CERTDIR=/certs \
    -v /docker/certs/ca:/certs/ca \
    -v /docker/certs/client:/certs/client \
    docker:dind
注意：如DOCKER_TLS_CERTDIR=空，使用的2376，否则使用的是2376

##### 4、创建客户端，引用证书
docker run -it --rm --network docker-dind-network \
    -e DOCKER_TLS_CERTDIR=/certs \
    -v /docker/certs/client:/certs/client:ro \
    docker:latest


#### 单独使用 
创建本地docker:dind容器
docker run --privileged -e DOCKER_TLS_CERTDIR= --network-alias docker --name docker-dind --hostname docker-dind -p 2375:2375 -p 2376:2376 -v /etc/docker/daemon.json:/etc/docker/daemon.json  -d docker:stable-dind