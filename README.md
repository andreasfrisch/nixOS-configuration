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


