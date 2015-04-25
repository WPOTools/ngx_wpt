# ngx_wpt

ngx_wpt is a plugin for NGINX that extends it to be able to route the incoming traffic for the WebPageTest instances between multiple servers (Scale out).

## Features

- Balzingly fast reverse-proxy and load balancer ( Thanks to NGINX )
- Zero-downtime reload of ngx_wpt configurations
- The ability to share the test agents between more than one WPT server. By sending them to ngx_wpt instead of directly hiting a WPT server.


## Table of content
- [How does it work?](#how-does-it-work-)
- [Installation](#installation)
- [Configuring ngx_wpt](#configuring-ngx_wpt)


# How Does It Work?

![ngx_wpt architecture](https://raw.githubusercontent.com/lafikl/ngx_wpt/master/arch.jpg)

All of the incoming traffic should be sent to ngx_wpt which will determine based on multiple factors who will serve that request from the pool of WPT servers.

**Request routing procedure**:
- If a request contains a test ID then ngx_wpt will check its WPT servers pool (as defined in /etc/wpt/conf.json) to see if it matches any, if so then it will send that request to it.
- Otherwise ngx_wpt will perform a round-robin algorithm to load balance the workload.



# Installation
This is a guide for Ubuntu 14.04.

### Install Prerequisites

- `sudo apt-get install build-essential libpcre3-dev libssl-dev git zip`
- `sudo apt-get install nginx`

### Install OpenResty 

- `wget http://openresty.org/download/ngx_openresty-1.7.10.1.tar.gz`
- `tar xzvf ngx_openresty-1.7.10.1.tar.gz`
- ```cd ngx_openresty-1.7.10.1/```

```
sudo ./configure \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-client-body-temp-path=/var/lib/nginx/body \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-log-path=/var/log/nginx/access.log \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--http-scgi-temp-path=/var/lib/nginx/scgi \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
--lock-path=/var/lock/nginx.lock \
--pid-path=/var/run/nginx.pid \
--with-luajit \
--with-http_dav_module \
--with-http_flv_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_sub_module \
--with-ipv6 \
--with-sha1=/usr/include/openssl \
--with-md5=/usr/include/openssl \
--with-http_stub_status_module \
--with-http_secure_link_module \
--with-http_sub_module
```

- `sudo make`
- `sudo make install`


### Install LuaRocks

- `cd ~`
- `wget http://keplerproject.github.io/luarocks/releases/luarocks-2.2.2.tar.gz`
```
sudo ./configure --prefix=/usr/local/openresty/luajit \
    --with-lua=/usr/local/openresty/luajit/ \
    --lua-suffix=jit-2.1.0-alpha \
    --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
```
- `sudo make build && sudo make install`
- `sudo make bootstrap`


### Install CJSON

- `sudo ./usr/local/openresty/luajit/bin/luarocks install lua-cjson`

### Install ngx_wpt

- `sudo mkdir /var/lib/ngx_wpt`
- `sudo mkdir /etc/wpt`
- `cd /var/lib/ngx_wpt`
- `git clone https://github.com/lafikl/ngx_wpt.git .`
- `sudo mv conf.json /etc/wpt`
- `sudo mv wpt.conf /etc/nginx/conf.d/`
- `sudo rm /etc/nginx/sites-enabled/default`
- `sudo service nginx restart`

# Configuring ngx_wpt

- Edit `/etc/wpt/conf.json` by adding your WPT hosts IPs and the ID for each server.
    There's no limits for how many WPT hosts you can add to the config file as long as the IDs are unique.
- Then run: `sudo nginx -s reload`
  Which will reload the configuration for ngx_wpt as well as NGINX configurations. **Without dropping requests**.

