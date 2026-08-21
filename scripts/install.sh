#!/usr/bin/env bash
# Usage: ./scripts/install.sh --host castitas --target root@<ip>
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOST=""
TARGET=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --host) HOST="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

[[ -z "$HOST" ]]   && { echo "ERROR: --host required"; exit 1; }
[[ -z "$TARGET" ]] && { echo "ERROR: --target required"; exit 1; }

SECRETS_FILE="$DOTFILES_DIR/secrets/${HOST}.yaml"
SOPS_CONFIG="$DOTFILES_DIR/.sops.yaml"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "==> Installing NixOS on $TARGET as host '$HOST'"
echo ""

# Step 1: Generate a temporary SSH host key on the target and derive age pubkey
echo "==> Fetching target SSH host key..."
# nixos-anywhere will generate host keys during install; we need them beforehand
# to encrypt secrets. We generate a temporary key pair, use it for secrets,
# and inject it as the real host key.
TEMP_KEY_DIR="$TMPDIR/etc/ssh"
mkdir -p "$TEMP_KEY_DIR"
ssh-keygen -t ed25519 -N "" -f "$TEMP_KEY_DIR/ssh_host_ed25519_key" -C "" -q

AGE_PUBKEY=$(nix shell nixpkgs#ssh-to-age --command \
  ssh-to-age < "$TEMP_KEY_DIR/ssh_host_ed25519_key.pub")

echo "    Age public key: $AGE_PUBKEY"

# Step 2: Register this key in .sops.yaml if not already present
if grep -q "$AGE_PUBKEY" "$SOPS_CONFIG"; then
  echo "==> Key already registered in .sops.yaml"
else
  echo "==> Registering key in .sops.yaml..."
  HOST_UPPER=$(echo "$HOST" | tr '[:lower:]' '[:upper:]')
  sed -i "s|age1${HOST_UPPER}_REPLACE_WITH_AGE_PUBKEY|${AGE_PUBKEY}|" "$SOPS_CONFIG"
  # If placeholder wasn't found, append a new entry
  if grep -q "REPLACE_WITH_AGE_PUBKEY" "$SOPS_CONFIG"; then
    echo "WARNING: Could not find placeholder in .sops.yaml for host '$HOST'."
    echo "         Add manually:  - &${HOST} ${AGE_PUBKEY}"
    echo "         Then re-run this script."
    exit 1
  fi
fi

# Step 3: Encrypt secrets for this host
echo "==> Encrypting secrets for $HOST..."
bash "$DOTFILES_DIR/scripts/secrets-update.sh" --host "$HOST" --age-key "$AGE_PUBKEY"

# Step 4: Run nixos-anywhere with injected host key + secrets
echo ""
echo "==> Running nixos-anywhere..."
nix run github:nix-community/nixos-anywhere -- \
  --flake "${DOTFILES_DIR}#${HOST}" \
  --extra-files "$TMPDIR" \
  "$TARGET"

echo ""
echo "==> Done! Machine will reboot into NixOS."
echo "    The SSH host key has been set — sops will decrypt secrets on first boot."
echo ""
echo "    Remember to commit the updated .sops.yaml:"
echo "    git add .sops.yaml secrets/${HOST}.yaml && git commit -m 'Add ${HOST} host key'"
