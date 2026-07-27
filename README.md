# Vintage Story Server

This repo runs a Vintage Story `1.22.0` server in Docker and places it behind a Tailscale sidecar container. The game server data is stored in `./data` (feel free to change this!).

## Host

1. In the Tailscale admin UI, create a new auth key.
2. Copy [.env.example](./vintage-story-server/.env.example) to `.env`.
3. Put your auth key in `.env` as `TS_AUTHKEY=...`.
4. Start the stack:

```bash
./run.sh
```

This will:
- build the Vintage Story server image from [Server.dockerfile](./vintage-story-server/Server.dockerfile)
- create `./data` if it does not already exist
- fix `./data` ownership with `sudo chown` if it is not writable by your user
- start both the Tailscale proxy and the game server with Docker Compose

The server is exposed on port `42420` over both `TCP` and `UDP`.

After the stack is up:

1. Open the Tailscale admin UI.
2. Find the machine created for this stack.
3. Use the Tailscale UI to share that machine.
4. Send the generated share link to your friends.

## Consumer

1. Install Tailscale and sign in.
2. Open the share link sent by the host.
3. Accept access to the shared machine in Tailscale.
4. Open Vintage Story and connect to the shared machine on port `42420`.
