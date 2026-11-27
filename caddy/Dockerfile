FROM alpine:3.23 AS builder
RUN apk add --no-cache git
RUN git clone --depth 1 https://github.com/ArabPixel/WebKitty.git /srv/webkitty \
    && rm -rf /srv/webkitty/.git

FROM caddy:2.11.9
COPY --from=builder /srv/webkitty /srv/webkitty
