#!/usr/bin/env bash
# ^ Shebang: run with whichever bash is first in PATH


# add_ingress_hosts.sh
#
# Usage: sudo ./add_ingress_hosts.sh [IP]
# If no IP is given, default to 192.168.56.90

set -euo pipefail
# -e  : exit immediately if any command exits non-zero
# -u  : treat unset variables as an error
# -o pipefail : a pipeline fails if *any* command fails

IP="${1:-192.168.56.90}"

HOSTS=(app.local grafana.app.local prometheus.app.local mailpit.app.local)

BLOCK_START="# --- REMLA ingress BEGIN ---"
BLOCK_END="# --- REMLA ingress END ---"
# Markers that wrap our managed section in /etc/hosts.

# Delete any previous run (lines between the markers)
sudo sed -i.bak "/$BLOCK_START/,/$BLOCK_END/d" /etc/hosts
# sudo           : /etc/hosts is root-owned
# sed            : stream editor
# -i.bak         : edit file in place AND keep a backup copy *.bak
# "/A/,/B/d"     : between lines matching A and lines matching B, delete
# Effect: cleans out old entries while preserving rest of file

{
  echo "$BLOCK_START"
  for h in "${HOSTS[@]}"; do
    printf '%s %s\n' "$IP" "$h"
    # Print "192.168.56.90 host.name" (or new IP if given)
  done
  echo "$BLOCK_END"
} | sudo tee -a /etc/hosts >/dev/null

echo "Added hosts → $IP"

#  try to flush local DNS cache (multi-platform)
if command -v dscacheutil >/dev/null; then
  # macOS path
  sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder
elif command -v systemd-resolve >/dev/null; then
  # Linux systemd path
  sudo systemd-resolve --flush-caches
fi
# 'command -v foo' returns 0 if foo is in PATH.
# We only flush if the appropriate tool exists.