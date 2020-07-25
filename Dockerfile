FROM alpine:3.11.6

# install the cloudposse alpine repository
ADD https://apk.cloudposse.com/ops@cloudposse.com.rsa.pub /etc/apk/keys/
RUN echo "@cloudposse https://apk.cloudposse.com/3.11/vendor" >> /etc/apk/repositories

# Use TLS for alpine default repos
RUN sed -i 's|http://dl-cdn.alpinelinux.org|https://alpine.global.ssl.fastly.net|g' /etc/apk/repositories && \
    echo "@testing https://alpine.global.ssl.fastly.net/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "@community https://alpine.global.ssl.fastly.net/alpine/edge/community" >> /etc/apk/repositories

# Install awscli
COPY requirements.txt /requirements.txt
RUN apk add python3 && \
        python3 -m pip install --upgrade pip setuptools wheel && \
        pip install -r /requirements.txt --ignore-installed --prefix=/usr --no-build-isolation --no-warn-script-location

# Install our utilities
RUN apk add --no-cache postgresql-client=12.2-r0 \
    jq \
    vault@cloudposse \
    bash
