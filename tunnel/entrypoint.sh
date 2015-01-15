#!/bin/bash
exec ssh -ND 0.0.0.0:10080 -o StrictHostKeyChecking=no ${USER}@${HOST}

