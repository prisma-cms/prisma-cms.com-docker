FROM caddy:2.10-builder AS builder

RUN xcaddy build \
    --output /usr/bin/caddy \
    --with github.com/caddy-dns/digitalocean

FROM caddy:2.10-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN apk update
RUN apk add mc
RUN apk add curl
# dig
RUN apk add bind-tools

WORKDIR /etc/caddy
