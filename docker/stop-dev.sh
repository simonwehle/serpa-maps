#!/bin/bash

echo "Stopping backend (if running)..."
# Attempt to stop backend process gracefully (adjust as needed)
pkill -f './serpa-maps' || echo "Backend process not running."

echo "Stopping Docker Compose services..."
docker-compose down

echo "Stopping Colima..."
colima stop

echo "All services stopped and Colima shut down."
