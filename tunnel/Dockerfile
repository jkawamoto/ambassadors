# AmbassadorS tunnel
FROM ubuntu:latest 
MAINTAINER Junpei Kawamoto <kawamoto.junpei@gmail.com>

RUN apt-get update && apt-get install -y ssh

ADD entrypoint.sh /root/

ENV USER tunnel
ENV PORT 10022
ENV PROXY_PORT 1080

EXPOSE 1080
ENTRYPOINT ["/root/entrypoint.sh"]
