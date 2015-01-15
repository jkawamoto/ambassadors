AmmbasadorS
============

Yet another Ambassador pattern over SSH.


Server side
------------
docker run -d --name ambassadors -v ~/.ssh/:/data/ -p 10022:22 --link mongo:mongo junpei/ambassadors server

Tunnel
-------
docker run -dt --name tunnel -v ~/.ssh:/root/.ssh -e PORT=10022 -e HOST=133.5.152.137 junpei/ambassadors tunnel

Client side
------------
docker run -d --name mongo_ambassadors --link tunnel:tunnel --expose 27017 -e PORT=27017 junpei/ambassadors client

License
=======
This software is released under the MIT License, see LICENSE.
