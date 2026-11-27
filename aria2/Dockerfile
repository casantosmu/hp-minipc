FROM alpine:3.22
RUN apk add --no-cache aria2
COPY --chmod=755 entrypoint.sh /usr/local/bin/aria2-entrypoint
USER 1000:1000
ENTRYPOINT ["/usr/local/bin/aria2-entrypoint"]
