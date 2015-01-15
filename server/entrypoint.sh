#!/bin/bash

useradd -m ${USER}
sed -ri "s/^(${USER}):[^:]*:(.*)$/\1:*:\2/" /etc/shadow

mkdir /home/${USER}/.ssh
cp /data/authorized_keys /home/${USER}/.ssh/
chmod 700 /home/${USER}/.ssh
chmod 600 /home/${USER}/.ssh/authorized_keys
chown -R ${USER}:${USER} /home/${USER}/.ssh

for ADDR in `env | grep "_PORT=tcp:"`; do

  IPPORT=${ADDR#*//}
  HOST=${IPPORT%:*}
  PORT=${IPPORT#*:}

  echo "socat TCP4-LISTEN:${PORT},fork,reuseaddr TCP4:${HOST}:${PORT}"
  socat TCP4-LISTEN:${PORT},fork,reuseaddr TCP4:${HOST}:${PORT} &

done   

/usr/sbin/sshd -D

