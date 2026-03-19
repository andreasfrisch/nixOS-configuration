# NixOS, Flake, and HomeManager, Oh My!

## Getting Started

On a fresh install of NixOS, start a `nix-shell` with git

> nix-shell -p git

Then clone this repository into `/home/user/<username>/.dotfiles` or wherever you prefer.
From here you can run

> make init

This setup everything in the right order.

## Configurations

`flake.nix` contains a few settings of note.
Most importantly `hostname`, `timezone`, `locale`, and `username`.

A few of the other settings are not yet true settings.

If you modify the `hostname` remember to change the reference in the Makefile as well.

## Custom theming

Simply create a new folder in the `/themes` directory.
This folder should contain a `colors.nix` and `wallpaper.png`.
Then set the `theme` variable in `flake.nix` to the name of the folder.

## Installing on a new machine

Boot the target machine from a NixOS USB ISO and note its IP address.
From this machine run:

```bash
make secrets HOST=castitas          # fetch password from 1Password, encrypt
make install TARGET=root@<ip>       # partition disk, install NixOS, inject secrets
```

The machine will reboot into a fully configured system — no further steps needed.

To add a new host, create `hosts/<hostname>/default.nix`, `disk.nix`, and `sops.nix`,
add it to `nixosConfigurations` in `flake.nix` and `.sops.yaml`, then run the above.

## Secrets

Passwords are managed with [sops-nix](https://github.com/Mic92/sops-nix).
Each host has an encrypted `secrets/<hostname>.yaml` keyed to its SSH host key.
`make secrets HOST=<hostname>` fetches the password from 1Password and re-encrypts it.
Encrypted secrets are safe to commit to git.


