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

Boot the target machine from a NixOS USB ISO. Then, on the live USB:

**1. Get a shell with the required tools**
```bash
nix-shell -p git
```

**2. Clone this repository**
```bash
git clone https://github.com/andreasfrisch/nixOS-configuration ~/.dotfiles
cd ~/.dotfiles
```

**3. Partition and format the disk**

Disko handles partitioning declaratively. Run it against the host config:
```bash
sudo nix run github:nix-community/disko -- --mode disko --flake .#castitas
```
This creates the EFI partition, swap, and root filesystem as defined in `hosts/castitas/disk.nix`.

**4. Update the hardware configuration**

Generate the hardware config for this specific machine and copy it into the host folder:
```bash
sudo nixos-generate-config --root /mnt --no-filesystems
cp /mnt/etc/nixos/hardware-configuration.nix ~/.dotfiles/hosts/castitas/hardware-configuration.nix
```
The `--no-filesystems` flag skips filesystem entries since disko already handles those.

**5. Install NixOS**
```bash
sudo nixos-install --flake ~/.dotfiles#castitas
```

**6. Set the user password**
```bash
sudo nixos-enter --root /mnt -c 'passwd frisch'
```

**7. Reboot**
```bash
reboot
```

**8. Apply home-manager config**

After logging in for the first time:
```bash
cd ~/.dotfiles
make home
```
Encrypted secrets are safe to commit to git.


