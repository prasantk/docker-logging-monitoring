#!/bin/bash
set -x
wget -qO- https://get.docker.com/ | sh
usermod -aG docker vagrant
#service docker start
docker version