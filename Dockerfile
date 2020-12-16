FROM quay.io/spivegin/golang:v1.15 AS build-env-go114
WORKDIR /opt/caddy_build/
ADD files/caddy_mods/* /opt/caddy_build/
RUN apt-get update && apt-get install -y gcc &&\
    git clone https://github.com/caddyserver/caddy.git &&\
    cp build.sh caddy &&\
    cp main.go caddy &&\
    cd caddy &&\
    go mod vendor &&\
    bash build.sh

FROM quay.io/spivegin/tlmbasedebian
ENV DINIT=1.2.2 
WORKDIR /opt/tlm
RUN mkdir /opt/bin 
COPY --from=build-env-go114 /opt/caddy_build/caddy/bin/caddy /opt/bin/caddy
COPY --from=build-env-go114 /opt/caddy_build/caddy/bin/caddy.exe /opt/caddy.exe
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