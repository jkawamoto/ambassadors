#!/bin/bash
echo "ssh -ND 0.0.0.0:${PROXY_PORT} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT}"
exec ssh -ND 0.0.0.0:${PROXY_PORT} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT}

