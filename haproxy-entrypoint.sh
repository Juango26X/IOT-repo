#!/bin/sh
# API_IP se pasa como variable de entorno al docker run
cat > /usr/local/etc/haproxy/haproxy.cfg <<CFG
global
    log stdout format raw local0
    maxconn 4096

defaults
    mode http
    log  global
    option httplog
    timeout connect 5s
    timeout client  50s
    timeout server  50s

frontend http_in
    bind *:80
    default_backend api_servers

backend api_servers
    balance roundrobin
    option httpchk GET /health
    server api1 ${API_IP}:8000 check
CFG

exec haproxy -f /usr/local/etc/haproxy/haproxy.cfg
