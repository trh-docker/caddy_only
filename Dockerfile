FROM quay.io/spivegin/gitonly:latest AS git

FROM quay.io/spivegin/golang:v1.15.2 AS builder
WORKDIR /opt/src/src/sc.tpnfc.us/askforitpro/

RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa && git config --global user.name "quadtone" && git config --global user.email "quadtone@txtsme.com"
COPY --from=git /root/.ssh /root/.ssh
RUN ssh-keyscan -H github.com > ~/.ssh/known_hosts &&\
    ssh-keyscan -H gitlab.com >> ~/.ssh/known_hosts &&\
    ssh-keyscan -H go.opencensus.io >> ~/.ssh/known_hosts &&\
    ssh-keyscan -H cloud.google.com >> ~/.ssh/known_hosts &&\
    ssh-keyscan -H google.golang.org >> ~/.ssh/known_hosts &&\
    ssh-keyscan -H golang.org >> ~/.ssh/known_hosts &&\
    ssh-keyscan -H git.apache.org >> ~/.ssh/known_hosts


WORKDIR /opt/caddy_build/
ADD files/caddy_mods/* /opt/caddy_build/
RUN apt-get update && apt-get install -y gcc &&\
    git clone git@github.com:caddyserver/caddy.git &&\
    cp build.sh caddy &&\
    cp main.go caddy 
     
