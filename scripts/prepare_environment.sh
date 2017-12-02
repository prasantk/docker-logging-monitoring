#!/bin/bash

echo -n "Setting up the max map count..."
echo 'vm.max_map_count=262144'| sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo -n "Setting up the elasticsearch directory..."
sudo mkdir -p /data/elasticsearch/data && sudo chown -R 1000:1000 /data
