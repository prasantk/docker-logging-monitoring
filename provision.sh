#!/bin/bash
set -x
wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker ubuntu
#service docker start
docker version