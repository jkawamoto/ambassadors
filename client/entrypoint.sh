#!/bin/bash
PROXY_IPPORT=${TUNNEL_PORT#*//}
PROXY_IP=${PROXY_IPPORT%:*}
PROXY_PORT=${PROXY_IPPORT#*:}

echo "socat TCP-LISTEN:${PORT},fork,reuseaddr SOCKS4:${PROXY_IP}:${HOST}:${PORT},socksport=${PROXY_PORT}"
exec socat TCP-LISTEN:${PORT},fork,reuseaddr SOCKS4:${PROXY_IP}:${HOST}:${PORT},socksport=${PROXY_PORT}
