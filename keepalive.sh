#!/bin/bash
set -e

: "${GH_TOKEN:?Thieu bien GH_TOKEN}"

mkdir -p ~/.ssh
if [ -f /app/id_ed25519 ]; then
  cp /app/id_ed25519 ~/.ssh/id_ed25519
  chmod 600 ~/.ssh/id_ed25519
else
  if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 -q
  fi
fi

gh ssh-key add ~/.ssh/id_ed25519.pub --title "railway-keepalive" >/dev/null 2>&1 || true

get_codespace() {
  if [ -n "$CODESPACE_NAME" ]; then
    echo "$CODESPACE_NAME"
    return
  fi
  gh codespace list --json name,lastUsedAt --limit 5 \
    -q 'sort_by(.[], .lastUsedAt) | reverse | .[0].name'
}

while true; do
  CS=$(get_codespace)
  if [ -z "$CS" ]; then
    echo "[$(date)] Khong tim thay codespace nao, thu lai sau 60s..."
    sleep 60
    continue
  fi
  echo "[$(date)] SSH vao codespace: $CS"
  gh codespace ssh -c "$CS" -- "while true; do date; sleep 60; done"
  echo "[$(date)] Session bi dut, reconnect trong 5s..."
  sleep 5
done
