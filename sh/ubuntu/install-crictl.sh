#!/bin/bash
#  Script that installs crictl/cri-o

  set -x


# crictl install:

# Assumes running sudo or as root...
# Based on: https://www.howtoforge.com/how-to-install-cri-o-container-runtime-on-ubuntu-22-04/


export OS=xUbuntu_22.04
export CRIO_VERSION=1.24

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" |sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS/ /" |sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION/$OS/Release.key | sudo apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key add -

sudo apt update

sudo apt info cri-o

sudo apt install -y cri-o cri-o-runc

sudo systemctl start crio

sudo systemctl enable crio

sudo apt install -y containernetworking-plugins


# handle: crio.conf
# wget mine:  /etc/crio/crio.conf
wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/crio-confBASE
cp /data/inet/crio-confBASE /etc/crio/crio.conf

# handle: 100-crio-bridge.conf
mv /etc/cni/net.d/100-crio-bridge.conf /etc/cni/net.d/100-crio-bridge-conf.dis

# wget mine: 11-crio-ipv4-bridge-confBASE
wget -P /data/inet https://raw.githubusercontent.com/ericm48/cmdzNThangs/refs/heads/main/sh/ubuntu/11-crio-ipv4-bridge-confBASE
cp /data/inet/11-crio-ipv4-bridge-confBASE /etc/cni/net.d/11-crio-ipv4-bridge.conf

sudo systemctl restart crio

sudo apt install -y cri-tools

sudo crictl --runtime-endpoint unix:///var/run/crio/crio.sock version

crictl version

crictl info

