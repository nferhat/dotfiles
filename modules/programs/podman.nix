{pkgs, ...}: {
  # I use podman as a safer Docker alternative.
  # Works fine, and is sometimes faster!
  virtualisation = {
    # Enable common container configuration in /etc/containers
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      # This is needed for contained spawned by podman-compose to talk to eachother
      # (stuff like named containers etc. in the local network)
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Additional useful tools
  environment.systemPackages = with pkgs; [dive podman-tui docker-compose];
}
