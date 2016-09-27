#!/bin/bash
set -e

CONFIGDIR=/ops/$1
SCRIPTSDIR=/ops/$2
RSYSLOG=/etc/rsyslog.conf

echo Installing Nginx...

apt-get -y update
apt-get install -y nginx
chmod a+w /etc/rsyslog.conf

echo '$ModLoad imudp' >> $RSYSLOG
echo '$UDPServerAddress 127.0.0.1' >> $RSYSLOG
echo '$UDPServerRun 514' >> $RSYSLOG

echo Configuring nginx...

# Consul config
cp $CONFIGDIR/consul/nginx.json /etc/consul.d/nginx.json

# Consul Template config
cp $CONFIGDIR/consul_template/nginx.hcl /etc/consul_template.d/nginx.hcl
cp $CONFIGDIR/consul_template/templates/nginx.ctmpl /opt/consul_template/nginx.ctmpl

# Upstart config
cp $SCRIPTSDIR/upstart/nginx.conf /etc/init/nginx.conf
