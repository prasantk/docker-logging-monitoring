#!/bin/bash

echo -n "Installing docker..."
wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker ubuntu