FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

ENV TITLE="SpotiFLAC Next" \
    PIXELFLUX_WAYLAND=true

RUN \
    echo "**** install packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        ffmpeg \
        libwebkit2gtk-4.1-0 && \
    echo "**** cleanup ****" && \
    rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

WORKDIR /opt/SpotiFLAC-Next

COPY SpotiFLAC-Next.AppImage ./

RUN \
    echo "**** extract SpotiFLAC ****" && \
    chmod +x SpotiFLAC-Next.AppImage && \
    ./SpotiFLAC-Next.AppImage --appimage-extract && \
    mv squashfs-root app && \
    rm SpotiFLAC-Next.AppImage

COPY /root /

EXPOSE 3001

VOLUME /config
