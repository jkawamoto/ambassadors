AmbassadorS
============
Yet another Ambassador pattern over SSH.

Install
--------
You can pull a built container.

```sh
$ docker pull jkawamoto/ambassadors
```

Useage
-------
AmbassadorS has three modes; server, client, tunnel.
Those modes are associated as follows.

(a container) ---> (AmbassadorS client) ---> (AmbassadorS tunnel) == ssh ==> (AmbassadorS server)

You need one server-mode container on each host which has containers to be linked and one tunnel-mode container on each "client" host. You also need client-mode containers for every linking containers.

**Example** If you have MySQL and MongoDB containers on host A, and a container on host B is linking those containers. You need to run a server-mode container linking the MySQL and MongoDB containers on host A.

```sh
$ docker run -d --name ambassadors_server \
             -v ~/.ssh/:/data/ -p 10022:22 \
             --link mongo:mongo --link mysql:mysql \
             jkawamoto/ambassadors server
```

The server-mode container requires `authorized_keys` in `/data/` and exposes port `22` for sshd.

On host B, you need to run a tunnel-mode container.

```sh
$ docker run -dt --name ambassadors_tunnel \
            -v ~/.ssh:/root/.ssh -e PORT=10022 -e HOST=<host a> \
            jkawamoto/ambassadors tunnel
```

The environment `PORT` is specified the port number of sshd on host A.

And you also need to run a client-mode container for MySQL and MongoDB.

```sh
$ docker run -d --name mysql_ambassadors \
             --link ambassadors_tunnel:tunnel --expose 3306 -e PORT=3306 \
             jkawamoto/ambassadors client
$ docker run -d --name mongo_ambassadors \
             --link ambassadors_tunnel:tunnel --expose 27017 -e PORT=27017 \
             jkawamoto/ambassadors client
```

Finally, you can use MySQL and MongoDB.

```sh
$ docker run -d --link mysql_ambassadors:mysql --link mongo_ambassadors:mongo some-app
```

License
=======
This software is released under the MIT License, see LICENSE.
