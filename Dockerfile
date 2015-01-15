FROM ubuntu:latest
MAINTAINER Junpei Kawamoto <kawamoto.junpei@gmail.com>

# Install relative packages.
RUN apt-get update && apt-get install -y ssh socat

# For sshd in server.
RUN mkdir /var/run/sshd
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
	 &&	echo "AuthorizedKeysFile %h/.ssh/authorized_keys" >> /etc/ssh/sshd_config 

# IP address to connect (used in tunnel).
ENV HOST 127.0.0.1

# User of AmbassadorS.
ENV USER tunnel

# Public port number of server.
ENV PORT 10022

# Port number of Socks proxy.
ENV PROXY_PORT 1080

EXPOSE 22
EXPOSE 1080

# Import and set the startup script.
ADD entrypoint.sh /root/
ENTRYPOINT ["/root/entrypoint.sh"]
