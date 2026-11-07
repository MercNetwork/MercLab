#!/usr/bin/env bash
set -euo pipefail

# mercury-install — partition, format and install a Mercury NixOS host.
#
#   sudo mercury-install <host> [flake]
#
#   <host>   a nixosConfigurations name from flake.nix (desktop, laptop, ...)
#   [flake]  path or URI of the MercLab flake (default: current directory)
#
# Run it from the NixOS live ISO, inside a clone of the repo:
#   git clone <your MercLab remote> ~/MercLab && cd ~/MercLab
#   sudo nix --extra-experimental-features "nix-command flakes" run .#install -- desktop

HOST="${1:-}"
FLAKE="${2:-.}"

if [ -z "${HOST}" ]; then
  echo "Usage: mercury-install <host> [flake]"
  echo ""
  echo "Hosts wired in flake.nix: desktop, laptop"
  echo ""
  echo "Example (from inside the repo on the live ISO):"
  echo "  sudo nix run .#install -- desktop"
  exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: mercury-install must be run as root (or via sudo)." >&2
  exit 1
fi

echo "=================================================="
echo " Mercury installer"
echo " Target host: ${HOST}"
echo " Flake:       ${FLAKE}"
echo "=================================================="
echo ""
echo "WARNING: This repartitions and FORMATS the disk declared in"
echo "hosts/${HOST}/disko.nix. Everything on that disk will be erased."
echo ""
read -r -p "Type the host name (${HOST}) to continue: " confirm
if [ "${confirm}" != "${HOST}" ]; then
  echo "Installation aborted."
  exit 0
fi

# 1. Partition and format
echo "--> [1/5] Running Disko for ${HOST}..."
disko --mode destroy,format,mount --flake "${FLAKE}#${HOST}"

# 2. Host identity (SSH host key, initrd unlock key, SOPS identity)
echo "--> [2/5] Creating host keys..."
mkdir -p /mnt/persist/etc/ssh /mnt/persist/etc/sops /mnt/persist/etc/secrets/initrd

if [ ! -f /mnt/persist/etc/ssh/ssh_host_ed25519_key ]; then
  ssh-keygen -t ed25519 -N "" -C "root@${HOST}" -f /mnt/persist/etc/ssh/ssh_host_ed25519_key
fi

if [ ! -f /mnt/persist/etc/secrets/initrd/dropbear_ed25519_host_key ]; then
  dropbearkey -t ed25519 -f /mnt/persist/etc/secrets/initrd/dropbear_ed25519_host_key >/dev/null
fi

if [ -n "${AGE_IDENTITY:-}" ]; then
  printf '%s\n' "${AGE_IDENTITY}" >/mnt/persist/etc/sops/identities.txt
elif [ ! -f /mnt/persist/etc/sops/identities.txt ]; then
  touch /mnt/persist/etc/sops/identities.txt
fi
chmod 600 /mnt/persist/etc/sops/identities.txt

# Without impermanence the system reads keys from /etc, so put copies there too.
mkdir -p /mnt/etc/ssh /mnt/etc/sops /mnt/etc/secrets/initrd
cp -a /mnt/persist/etc/ssh/ssh_host_ed25519_key* /mnt/etc/ssh/
cp -a /mnt/persist/etc/secrets/initrd/. /mnt/etc/secrets/initrd/
cp -a /mnt/persist/etc/sops/identities.txt /mnt/etc/sops/

echo "--------------------------------------------------"
echo " Age public key for ${HOST} (add it to .sops.yaml):"
ssh-to-age < /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub
echo "--------------------------------------------------"

# 3. Install
echo "--> [3/5] Installing NixOS (this takes a while)..."
nixos-install --flake "${FLAKE}#${HOST}" --no-root-passwd

# 4. Put the repo where the dotfile symlinks expect it (~/MercLab)
echo "--> [4/5] Copying the repo into the new home directory..."
USER_NAME="$(nix --extra-experimental-features "nix-command flakes" eval --raw "${FLAKE}#nixosConfigurations.${HOST}.config.mercury.system.user.name" 2>/dev/null || echo mercury)"
TARGET="/mnt/home/${USER_NAME}/MercLab"
if [ -d "${FLAKE}" ] && [ ! -e "${TARGET}" ]; then
  mkdir -p "$(dirname "${TARGET}")"
  cp -a "$(realpath "${FLAKE}")" "${TARGET}"
  # First normal user is uid 1000, group "users" is gid 100
  chown -R 1000:100 "/mnt/home/${USER_NAME}"
  echo "    Repo copied to /home/${USER_NAME}/MercLab"
else
  echo "    Skipped (flake is not a local directory, or ${TARGET} exists)."
  echo "    After first boot: git clone <your MercLab remote> ~/MercLab"
fi

echo "--> [5/5] Done."
echo "=================================================="
echo " Reboot, log in as ${USER_NAME} (default password: chloe),"
echo " then change the password — see docs: First boot."
echo "=================================================="
