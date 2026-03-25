#!/bin/bash
set -e

chown -R openclaw:openclaw /data
chmod 700 /data

# Persist Homebrew on the volume so brew-installed tools survive redeploys
if [ ! -d /data/.linuxbrew ]; then
  cp -a /home/linuxbrew/.linuxbrew /data/.linuxbrew
fi

rm -rf /home/linuxbrew/.linuxbrew
ln -sfn /data/.linuxbrew /home/linuxbrew/.linuxbrew

# Ensure Go module/bin cache dirs exist on the persistent volume
mkdir -p /data/.go/bin
chown -R openclaw:openclaw /data/.go

# Add persistent Go bin to PATH so go-installed tools survive redeploys
export PATH="/data/.go/bin:${PATH}"

exec gosu openclaw node src/server.js
