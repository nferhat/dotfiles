<h1 align=center>nferhat's system configuration</h1>

My systems configuration deployed using NixOS + user `$HOME` directory configuration deployed using home-manager, current composed of:

| System (Hostname) | Description                                                                     |
|------------------ | ------------------------------------------------------------------------------- |
| `thinkpad-t14s`   | Primary laptop, acquired 23/01/2025                                             |
| `hp-da0018nk`     | HP laptop, used as a secondary machine for tests                                |

## Directory structure

This flake is organized using [`hercules-ci/flake-parts`](https://github.com/hercules-ci/flake-parts), using the following directory structure:

- `hosts`
    * `default.nix` - declare `nixosConfigurations` flake output.
    * `<hostname>/` - per-host configuration. (see table above for all hostnames)
- `modules`
    * `default.nix` - declare `nixosModules` and `homeManagerModules` flake outputs.
    * `theme/` - Custom theme module, see `modules/theme/README.md`.
    * `nixos/` - NixOS specific modules.
    * `home-manager/` - home-manager specific modules.
- `home`
    * `default.nix` - declare `homeManagerConfigurations` flake output.
    * `nferhat.nix` - home configuration for user `nferhat`
    * See [`home/README.md`](./home/README.md) for more detailed information
- `packages`
    * `default.nix` - declare `packages` flake output.
    * `mons.nix` - Command-Line Installer and Manager for Celeste Modding.

## Rice screenshots

Nothing much really, since I didn't write a shell yet...

![image](https://github.com/user-attachments/assets/1ea34d7e-05ca-41b3-bec1-a13195689124)
![image](https://github.com/user-attachments/assets/b370014a-f7f2-42a8-8325-b639e7a130b2)


## Acknowledgments

- [`fufexan/dotfiles`](https://github.com/fufexan/dotfiles) copied some nix stuff from here and there
- [`hlissner/dotfiles`](https://github.com/hlissner/dotfiles) same as fufexan's dotfiles.
- [`rxyhn/yuki`](https://github.com/rxyhn/yuki) same as fufexan's dotfiles.
