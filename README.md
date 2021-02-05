# docker-in-docker

#### 介绍
docker-in-docker 扩展

#### 官方文档：
https://hub.docker.com/_/docker
https://docs.gitlab.com/ee/ci/docker/using_docker_build.html
https://about.gitlab.com/releases/2019/07/31/docker-in-docker-with-docker-19-dot-03/


#### 常规使用

##### 1、创建证书目录
``` shell
mkdir /docker
mkdir /docker/certs
mkdir /docker/certs/ca
mkdir /docker/certs/client
```

##### 2、创建网络
``` docker
docker network create docker-dind-network
```

##### 3、创建docker-daemon
``` docker
docker run --privileged --name docker-dind -d \
    --network docker-dind-network --network-alias docker \
    -e DOCKER_TLS_CERTDIR=/certs \
    -v /docker/certs/ca:/certs/ca \
    -v /docker/certs/client:/certs/client \
    docker:dind
```

注意：如DOCKER_TLS_CERTDIR=空，使用的2376，否则使用的是2376

##### 4、创建客户端，引用证书
``` docker
docker run -it --rm --network docker-dind-network \
    -e DOCKER_TLS_CERTDIR=/certs \
    -v /docker/certs/client:/certs/client:ro \
    docker:latest
```

#### 单独使用 
创建本地docker:dind容器
``` docker
docker run --privileged -e DOCKER_TLS_CERTDIR= \
    --network-alias docker \
    --name docker-dind --hostname docker-dind \
    -p 2375:2375 -p 2376:2376 \
    -v /etc/docker/daemon.json:/etc/docker/daemon.json \ 
    -d docker:stable-dind
```

#### 添加 git,docker-compose
``` docker
FROM docker:stable
RUN apk add --no-cache git
RUN apk add --no-cache py3-pip python3-dev libffi-dev openssl-dev curl gcc libc-dev make && pip3 install docker-compose
```
或者
``` docker
FROM docker:stable-git
RUN apk add --no-cache py3-pip python3-dev libffi-dev openssl-dev curl gcc libc-dev make && pip3 install docker-compose
```

#### 编译推送脚本
``` shell
#!/usr/bin/env bash
set -e
docker build -t zbdbx/docker:stable-git-compose .
docker login -u zbdbx -p $Docker_Hub_PASSWORD https://registry-1.docker.io/v2/
docker push zbdbx/docker:stable-git-compose
```
使用  https://hub.docker.com/repository/docker/zbdbx/docker
``` shell
docker pull zbdbx/docker:stable-git-compose
```

#### 将本地docker port暴露出来 
docker run --privileged --name docker -p 2375:2375 -p 2376:2376 -v /etc/docker/daemon.json:/etc/docker/daemon.json -v /var/lib/docker:/var/lib/docker zbdbx/docker:stable-git-compose
