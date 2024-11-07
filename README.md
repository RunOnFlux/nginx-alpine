# Nginx Alpine Web Server with custom configurations.

## Current ENV variables

```HTML_DIR=${HTML_DIR:-/home/nginx/uploads}```

```CONF_FILE=${CONF_FILE:-/etc/nginx/conf.d/default.conf}```

## Build from source:

```git clone https://github.com/RunOnFlux/nginx-alpine.git```

```cd nginx-alpine```

```docker build -t yourusername/nginx:alpine-dev .```
