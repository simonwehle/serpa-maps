#!/bin/bash

echo "Starting Colima..."
colima start

while [ ! -S ~/.colima/default/docker.sock ]; do
  sleep 1
done

echo "Starting Docker Compose services and waiting until healthy..."
docker-compose up -d --wait

echo "All services are healthy. Starting backend..."

(
  cd ../backend || exit 1
  go build 
  ./serpa-maps
)

