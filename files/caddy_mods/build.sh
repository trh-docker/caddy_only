#!/bin/bash
mkdir /opt/caddy_build/bin
go build -o /opt/caddy_build/caddy/bin/caddy2 /opt/caddy_build/cmd/caddy/main.go
export GOOS=windows
go build -o /opt/caddy_build/caddy/bin/caddy2.exe /opt/caddy_build/cmd/caddy/main.go
