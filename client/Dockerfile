# AmbassadorS client
FROM ubuntu:latest
MAINTAINER Junpei Kawamoto <kawamoto.junpei@gmail.com>

RUN apt-get update && apt-get install -y socat mongodb

ADD entrypoint.sh /root/

ENV HOST 127.0.0.1
ENTRYPOINT ["/root/entrypoint.sh"]
