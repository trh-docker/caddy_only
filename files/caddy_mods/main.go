package main

import (
        "github.com/caddyserver/caddy/caddy/caddymain"

        // plug in plugins here, for example:
        // _ "import/path/here"
        // plug in the standard directives
        _ "github.com/caddyserver/caddy/caddyhttp/basicauth"
        _ "github.com/caddyserver/caddy/caddyhttp/bind"

        //      _ "github.com/caddyserver/caddy/caddyhttp/browse"
        _ "github.com/caddyserver/caddy/caddyhttp/errors"
        _ "github.com/caddyserver/caddy/caddyhttp/expvar"
        _ "github.com/caddyserver/caddy/caddyhttp/extensions"
        _ "github.com/caddyserver/caddy/caddyhttp/fastcgi"
        _ "github.com/caddyserver/caddy/caddyhttp/gzip"
        _ "github.com/caddyserver/caddy/caddyhttp/header"

        //      _ "github.com/caddyserver/caddy/caddyhttp/index"
        _ "github.com/caddyserver/caddy/caddyhttp/internalsrv"
        _ "github.com/caddyserver/caddy/caddyhttp/limits"
        _ "github.com/caddyserver/caddy/caddyhttp/log"

        //      _ "github.com/caddyserver/caddy/caddyhttp/markdown"
        _ "github.com/caddyserver/caddy/caddyhttp/mime"
        _ "github.com/caddyserver/caddy/caddyhttp/pprof"
        _ "github.com/caddyserver/caddy/caddyhttp/proxy"
        _ "github.com/caddyserver/caddy/caddyhttp/push"
        _ "github.com/caddyserver/caddy/caddyhttp/redirect"
        _ "github.com/caddyserver/caddy/caddyhttp/requestid"
        _ "github.com/caddyserver/caddy/caddyhttp/rewrite"
        _ "github.com/caddyserver/caddy/caddyhttp/root"
        _ "github.com/caddyserver/caddy/caddyhttp/status"
        _ "github.com/caddyserver/caddy/caddyhttp/templates"
        _ "github.com/caddyserver/caddy/caddyhttp/timeouts"
        _ "github.com/caddyserver/caddy/caddyhttp/websocket"
        _ "github.com/caddyserver/caddy/onevent"
        //cors
        _ "github.com/captncraig/cors"
        // 3rd party plugins
        // _ "github.com/caddyserver/dnsproviders/digitalocean"
        // docker proxy
        //_ "github.com/lucaslorentz/caddy-docker-proxy/plugin"
        // minify
        //_ "github.com/hacdias/caddy-minify"
        // CORS
        //_ "github.com/captncraig/cors"
)

func main() {
        // optional: disable telemetry
        caddymain.EnableTelemetry = false
        caddymain.Run()
}
