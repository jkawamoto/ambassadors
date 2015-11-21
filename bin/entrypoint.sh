#!/bin/bash
#
# entrypoint.sh
#
# Copyright (c) 2015 Junpei Kawamoto
#
# This software is released under the MIT License.
#
# http://opensource.org/licenses/mit-license.php
#
case "$1" in

	server)

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
		;;


	client)

		PROXY_IPPORT=${TUNNEL_PORT#*//}
		PROXY_IP=${PROXY_IPPORT%:*}

		echo "socat TCP-LISTEN:${PORT},fork,reuseaddr SOCKS4:${PROXY_IP}:${HOST}:${PORT},socksport=${TUNNEL_ENV_PROXY_PORT}"
		exec socat TCP-LISTEN:${PORT},fork,reuseaddr SOCKS4:${PROXY_IP}:${HOST}:${PORT},socksport=${TUNNEL_ENV_PROXY_PORT}
		;;


	tunnel)

		echo "ssh -ND 0.0.0.0:${PROXY_PORT} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p ${PORT} ${USER}@${HOST}"
		exec ssh -ND 0.0.0.0:${PROXY_PORT} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p ${PORT} ${USER}@${HOST}
		;;

	*)

		exec $@

esac
