#!/usr/bin/env bash
# Usage: ./scripts/secrets-update.sh --host castitas [--age-key age1...]
# Fetches password from 1Password, hashes it, encrypts into secrets/<host>.yaml
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOST=""
AGE_KEY=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --host) HOST="$2"; shift 2 ;;
    --age-key) AGE_KEY="$2"; shift 2 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

[[ -z "$HOST" ]] && { echo "ERROR: --host required"; exit 1; }

SECRETS_FILE="$DOTFILES_DIR/secrets/${HOST}.yaml"

# If no age key provided, derive from this machine's SSH host key
if [[ -z "$AGE_KEY" ]]; then
  if [[ ! -f /etc/ssh/ssh_host_ed25519_key.pub ]]; then
    echo "ERROR: No SSH host key found and no --age-key provided."
    exit 1
  fi
  AGE_KEY=$(nix shell nixpkgs#ssh-to-age --command \
    ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub)
fi

echo "==> Signing in to 1Password..."
eval "$(op signin)"

echo "==> Fetching password from 1Password..."
OP_PASSWORD=$(op item get "${HOST}" --fields label=password 2>/dev/null \
  || op item get "NixOS" --fields label=password 2>/dev/null \
  || { echo "ERROR: No 1Password item named '${HOST}' or 'NixOS' found."; exit 1; })

echo "==> Hashing password..."
HASHED=$(echo "$OP_PASSWORD" | nix shell nixpkgs#mkpasswd --command \
  mkpasswd --stdin --method=sha-512)

echo "==> Writing encrypted secrets to $SECRETS_FILE..."
printf 'user:\n    hashedPassword: %s\n' "$HASHED" \
  | nix shell nixpkgs#sops --command \
    sops --encrypt \
      --age "$AGE_KEY" \
      --input-type yaml \
      --output-type yaml \
      /dev/stdin > "$SECRETS_FILE"

echo "==> Done. $SECRETS_FILE updated."
