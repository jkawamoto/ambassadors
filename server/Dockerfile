# AmbassadorS server
FROM ubuntu:latest

# Installing SSH
RUN apt-get update && apt-get install -y ssh socat

RUN mkdir /var/run/sshd
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
	 &&	echo "AuthorizedKeysFile %h/.ssh/authorized_keys" >> /etc/ssh/sshd_config 

ADD entrypoint.sh /root/

ENV USER tunnel
EXPOSE 22
ENTRYPOINT ["/root/entrypoint.sh"]