# AmbassadorS tunnel
FROM ubuntu:latest 
MAINTAINER Junpei Kawamoto <kawamoto.junpei@gmail.com>

RUN apt-get update && apt-get install -y ssh

ADD entrypoint.sh /root/

EXPOSE 10080
ENTRYPOINT ["/root/entrypoint.sh"]
