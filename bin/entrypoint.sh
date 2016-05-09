#!/bin/bash
#
# entrypoint.sh
#
# Copyright (c) 2015-2016 Junpei Kawamoto
#
# This software is released under the MIT License.
#
# http://opensource.org/licenses/mit-license.php
#
case "$1" in

	server)

		if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then

			/usr/bin/ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key

		fi

		adduser -S ${USER}
		addgroup -S ${USER}
		sed -ri "s/^(${USER}):[^:]*:(.*)$/\1:*:\2/" /etc/shadow

		mkdir -p /home/${USER}/.ssh
		cp /data/authorized_keys /home/${USER}/.ssh/
		chmod 700 /home/${USER}/.ssh
		chmod 600 /home/${USER}/.ssh/authorized_keys
		chown -R ${USER}:${USER} /home/${USER}/.ssh

		for ADDR in `env | grep "_PORT=tcp:"`; do

			IPPORT=${ADDR#*//}
			HOST=${IPPORT%:*}
			PORT=${IPPORT#*:}

			echo "socat $2 TCP4-LISTEN:${PORT},fork,reuseaddr TCP4:${HOST}:${PORT}"
			socat $2 TCP4-LISTEN:${PORT},fork,reuseaddr TCP4:${HOST}:${PORT} &

		done

		if [ $2 = "-v" ]; then
			SSHD_FLAG=-d
		fi

		echo "/usr/sbin/sshd -D $SSHD_FLAG"
		/usr/sbin/sshd -D $SSHD_FLAG
		;;


	client)

		PROXY_IPPORT=${TUNNEL_PORT#*//}
		PROXY_IP=${PROXY_IPPORT%:*}

		echo "socat $2 TCP-LISTEN:${PORT},fork,reuseaddr SOCKS4:${PROXY_IP}:${HOST}:${PORT},socksport=${TUNNEL_ENV_PROXY_PORT}"
		exec socat $2 TCP-LISTEN:${PORT},fork,reuseaddr SOCKS4:${PROXY_IP}:${HOST}:${PORT},socksport=${TUNNEL_ENV_PROXY_PORT}
		;;


	tunnel)

		echo "ssh $2 -ND 0.0.0.0:${PROXY_PORT} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p ${PORT} ${USER}@${HOST}"
		exec ssh $2 -ND 0.0.0.0:${PROXY_PORT} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p ${PORT} ${USER}@${HOST}
		;;

	*)

		exec $@

esac
