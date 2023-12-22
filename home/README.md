# home-manager setup

This flake can be used to deploy my dotfiles to your `$HOME` directory, using the standalone `home-manager` tool.

Exposed home-manager configurations:
- [`nferhat`](./nferhat.nix)

## Directory structure

- `default.nix` - declare `homeManagerConfigurations` flake output
- `nferhat.nix` - home configuration for user `nferhat`
- `programs/` - configuration for programs independent from desktop session
- `services.nix` - configuration for services independent from desktop session
