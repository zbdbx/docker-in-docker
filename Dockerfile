FROM docker:stable-git
LABEL BASE_IMG=docker:stable-git KEYS=docker,compose,git,tzdate
RUN set -e && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update && apk add --no-cache tzdata py3-pip python3-dev libffi-dev openssl-dev curl gcc libc-dev make \
    && pip3 install -i https://mirrors.aliyun.com/pypi/simple docker-compose
