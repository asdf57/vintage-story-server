# Vintage Story Server

This repo runs a Vintage Story `1.22.0` server in Docker and places it behind a Tailscale sidecar container. The game server data is stored in `./data` (feel free to change this!).

## Host

1. In the Tailscale admin UI, create a new auth key.
2. Copy `.env.example` to `.env`.
3. Put your auth key in `.env` as `TS_AUTHKEY=...`.
4. Start the stack:

```bash
./run.sh
```

This will:
- build the Vintage Story server image from `Server.dockerfile`
- create `./data` if it does not already exist
- fix `./data` ownership with `sudo chown` if it is not writable by your user
- start both the Tailscale proxy and the game server with Docker Compose

The server is exposed on port `42420` over both `TCP` and `UDP`.

After the stack is up:

1. Open the Tailscale admin UI.
2. Find the machine created for this stack.
3. Use the Tailscale UI to share that machine.
4. Send the generated share link to your friends.

## Scripts

These are the host-side scripts you are expected to run directly.

`./run.sh`
- Builds and starts the full stack.
- Ensures `./data` exists and is writable by your user.
- Waits for `data/serverconfig.json` to appear, then sets `WhitelistMode` to `1`.
- Use this for first boot, rebuilds, upgrades, and normal restarts.

`./stop.sh`
- Stops the Compose stack.
- Use this when you want to shut down both the Vintage Story server and the Tailscale sidecar cleanly.

## Tunables

These are the main values future hosts may want to adjust.

`TS_AUTHKEY`
- Defined in `.env`.
- This is the Tailscale auth key used by the proxy container to join your tailnet.
- Change this whenever you rotate keys or move the stack to a different Tailscale account or tailnet.

`./data`
- Defined in `docker-compose.yml` as the host bind mount for `/srv/gameserver/data/vs`.
- This contains the server world, saves, and generated config like `serverconfig.json`.
- Change this if you want the game data stored somewhere else on the host.

`SERVER_VER`
- Defined in `Server.dockerfile`.
- This controls which Vintage Story server version is downloaded into the image.
- Change this when upgrading or pinning the server version.

`cpus`, `mem_limit`, `mem_reservation`
- Defined in `docker-compose.yml` under the `server` service.
- These control how much CPU and memory the Vintage Story server container can use.
- Change these if the server needs more resources or if you want to constrain it more aggressively on a smaller host.

`42420`
- Defined in `docker-compose.yml` as the published `TCP` and `UDP` port.
- This is the default Vintage Story server port.
- Change this only if you also intend to run the game server on a different port in its config.

## Consumer

1. Install Tailscale and sign in.
2. Open the share link sent by the host.
3. Accept access to the shared machine in Tailscale.
4. Open Vintage Story and connect to the shared machine on port `42420`.
