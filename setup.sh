#!/bin/sh
# Adds the Stats Magic apt repository, then installs Stats Magic Host + SM²:
#   curl -fsSL https://steezyt33.github.io/stats-magic-host-downloads/setup.sh | sudo sh
# Later upgrades come with the system's own: sudo apt update && sudo apt upgrade
set -eu
base=https://steezyt33.github.io/stats-magic-host-downloads
[ "$(id -u)" = 0 ] || { echo "Run it with sudo: curl -fsSL $base/setup.sh | sudo sh" >&2; exit 1; }
[ "$(dpkg --print-architecture)" = amd64 ] || { echo "Stats Magic needs a 64-bit x86 (amd64) computer." >&2; exit 1; }

install -d -m 0755 /usr/share/keyrings
curl -fsSL "$base/statsmagic.gpg" -o /usr/share/keyrings/statsmagic.gpg.new
mv /usr/share/keyrings/statsmagic.gpg.new /usr/share/keyrings/statsmagic.gpg
chmod 0644 /usr/share/keyrings/statsmagic.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/statsmagic.gpg] $base stable main" \
  > /etc/apt/sources.list.d/statsmagic.list

apt-get update
apt-get install -y statsmagic
