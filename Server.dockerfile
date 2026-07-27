FROM debian:trixie-slim

ARG SERVER_VER="1.22.0"
ARG HOST_UID="1000"
ARG HOST_GID="1000"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        adduser \
        ca-certificates \
        tar \
        wget \
    && wget https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb \
    && dpkg -i /tmp/packages-microsoft-prod.deb \
    && rm /tmp/packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends dotnet-runtime-10.0 \
    && rm -rf /var/lib/apt/lists/*

RUN addgroup --gid "${HOST_GID}" gameserver \
    && adduser \
        --uid "${HOST_UID}" \
        --gid "${HOST_GID}" \
        --shell /bin/bash \
        --disabled-password \
        --gecos "" \
        gameserver

RUN mkdir -p /srv/gameserver/vintagestory /srv/gameserver/data/vs

WORKDIR /srv/gameserver/vintagestory

RUN wget https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_${SERVER_VER}.tar.gz \
    && tar xzf vs_server_linux-x64_${SERVER_VER}.tar.gz \
    && rm vs_server_linux-x64_${SERVER_VER}.tar.gz

RUN chown -R gameserver:gameserver /srv/gameserver

USER gameserver

ENTRYPOINT [ "dotnet", "VintagestoryServer.dll", "--dataPath", "/srv/gameserver/data/vs" ]
