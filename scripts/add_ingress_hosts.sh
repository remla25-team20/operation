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

IP="${1:-192.168.56.90}"	# Obtain IP	 (default: 192.168.56.90)
IP_HEAD="${IP%.*}"		# Obtain IP head (default: 192.168.56	)
IP_TAIL="${IP##*.}"		# Obtain IP tail (default: 	     .90)

# Obtain Istio IP. If not given, increments IP.	 (default: 192.168.56.91)
IP_ISTIO="${2:-${IP_HEAD}.$(((${IP_TAIL}+1) % 256))}"

HOSTS=(app.local grafana.app.local prometheus.app.local mailpit.app.local)

# Istio host must be last; it receives a different IP
HOSTS+=(app-istio.local)

IPS=()
for _ in "${HOSTS[@]:1}"; do IPS+=("$IP"); done
IPS+=("$IP_ISTIO")

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
  for i in "${!HOSTS[@]}"; do
    printf '%s %s\n' "${IPS[i]}" "${HOSTS[i]}"
  done
  echo "$BLOCK_END"
} | sudo tee -a /etc/hosts >/dev/null

echo "Added hosts → $IP"
echo "Istio host  → $IP_ISTIO"

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
