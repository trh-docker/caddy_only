FROM quay.io/spivegin/golang:v1.13 AS build-env-go113
WORKDIR /opt/caddy_build/
ADD files/caddy_mods/main.go /opt/caddy_build/
RUN apt-get update && apt-get install -y gcc &&\
    go mod init caddy &&\
    go get github.com/caddyserver/caddy &&\
    go build

FROM quay.io/spivegin/tlmbasedebian
ENV DINIT=1.2.2 
WORKDIR /opt/tlm
RUN mkdir /opt/bin 
COPY --from=build-env-go113 /opt/caddy_build/caddy /opt/bin/caddy
ADD https://github.com/Yelp/dumb-init/releases/download/v${DINIT}/dumb-init_${DINIT}_amd64.deb /tmp/dumb-init_amd64.deb

ADD https://raw.githubusercontent.com/adbegon/pub/master/AdfreeZoneSSL.crt /usr/local/share/ca-certificates/
ADD files/bash/caddy_entry.sh /opt/bin/entry.sh
RUN update-ca-certificates --verbose &&\
    chmod +x /opt/bin/caddy &&\
    ln -s /opt/bin/caddy /bin/caddy &&\
    chmod +x /opt/bin/entry.sh &&\
    dpkg -i /tmp/dumb-init_amd64.deb && \
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

EXPOSE 80 443 8080 8443
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/bin/entry.sh"]