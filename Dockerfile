FROM docker:stable-git
RUN set -e && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache py3-pip python3-dev libffi-dev openssl-dev curl gcc libc-dev make \
    && pip3 install docker-compose