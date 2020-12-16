FROM quay.io/spivegin/gitonly:latest AS git

FROM quay.io/spivegin/golang:v1.15.2 AS builder
WORKDIR /opt/src/src/sc.tpnfc.us/askforitpro/

RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa && git config --global user.name "quadtone" && git config --global user.email "quadtone@txtsme.com"
COPY --from=git /root/.ssh /root/.ssh
RUN ssh-keyscan -H github.com > ~/.ssh/known_hosts &&\
    ssh-keyscan -H gitlab.com >> ~/.ssh/known_hosts &&\
    ssh-keyscan -H go.opencensus.io >> ~/.ssh/known_hosts &&\
    ssh-keyscan -H cloud.google.com >> ~/.ssh/known_hosts &&\
    ssh-keyscan -H git.apache.org >> ~/.ssh/known_hosts


WORKDIR /opt/caddy_build/
ADD files/caddy_mods/* /opt/caddy_build/
RUN apt-get update && apt-get install -y gcc &&\
    git clone git@github.com:caddyserver/caddy.git &&\
    cp build.sh caddy &&\
    cp main.go caddy &&\
    cd caddy 

RUN go mod vendor &&\
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