# Secrets with sops-nix

Secrets (Wi-Fi passwords, API tokens, your password hash) are stored
**encrypted** in the repo and decrypted at boot on the machines allowed to read
them. sops-nix is already enabled on every NixOS host.

## Keys

- **Each machine** has an age key derived from its SSH host key. The installer
  printed it; get it again with
  `nix-shell -p ssh-to-age --run 'ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub'`.
- **You** need a personal age key to edit secrets:
  ```bash
  mkdir -p ~/.config/sops/age
  nix-shell -p age --run 'age-keygen -o ~/.config/sops/age/keys.txt'
  ```
  Back this file up in your password manager. Lose it and every machine key,
  and the secrets are gone.

## `.sops.yaml` (repo root)

```yaml
keys:
  - &mercury age1yourpersonalkey...
  - &desktop age1desktophostkey...
  - &laptop  age1laptophostkey...
creation_rules:
  - path_regex: secrets/[^/]+\.yaml$
    key_groups:
      - age: [*mercury, *desktop, *laptop]
```

## Create and use a secret

```bash
nix develop            # gives you sops
sops secrets/secrets.yaml
```

```yaml
mercury-password: $6$...your hash...
wifi-home: supersecret
```

In a host (or `hosts/base.nix` for all):

```nix
{ config, ... }: {
  mercury.security.sops_nix.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.secrets.mercury-password.neededForUsers = true;
  mercury.system.user.hashedPasswordFile = config.sops.secrets.mercury-password.path;
}
```

After adding a machine to `.sops.yaml`, re-encrypt: `sops updatekeys secrets/secrets.yaml`.

Secrets appear at `/run/secrets/<name>`, readable by root unless you set
`sops.secrets.<name>.owner`.
