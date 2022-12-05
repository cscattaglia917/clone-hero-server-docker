# clone-hero-server 🎸 🥁 🐳

Docker image for Clone Hero dedicated server software.

```$ docker run --rm -p 14242:14242/udp ghcr.io/cscattaglia917/clone-hero-server-docker:latest```

The Docker image exposes port 14242 for network communication by default. This can be configured in `settings.ini`

`settings.ini` is stored in `/usr/src/clonehero/config`. So if you want to modify it, create a `config` directory and use:

```$ docker run --rm -p 14242:14242/udp -v $(pwd)/config:/usr/src/clonehero/config ghcr.io/cscattaglia917/clone-hero-server-docker:latest```
