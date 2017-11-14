#!/bin/bash
set -x
wget -qO- https://get.docker.com/ | sh
usermod -aG docker ubuntu
#service docker start
docker version