{...}: {
  # Syncthing is mostly here to sync my notes and my password database.
  # Since I use KeePassXC, there's no sharing built-in.
  nferhat.services.syncthing = {
    enable = true;
    # FIXME: Perhaps declare some stuff to sync here instead of it being only set in the Web UI?
    # I dunno about that, you already know way too much about me with this config here.
  };

  # Open the ports needed for transfer and discovery
  networking.firewall = {
    allowedTCPPorts = [22000];
    allowedUDPPorts = [21027 22000];
  };
}
