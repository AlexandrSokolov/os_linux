#!/bin/bash
# Fix Network Stack Glitch on Ubuntu

# exit if any command returns a non-zero exit status (fails)
set -e

echo "[INFO] Flushing DNS cache using resolvectl..."
sudo resolvectl flush-caches

echo "[INFO] Restarting systemd-resolved service..."
sudo systemctl restart systemd-resolved

echo "[INFO] Restarting NetworkManager..."
sudo systemctl restart NetworkManager

echo "[INFO] Resetting routing tables..."
sudo ip route flush table main

echo "[INFO] Network stack reset completed successfully."