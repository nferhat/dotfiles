{ ... }: {
  # Syncthing is mostly here to sync my notes and my password database.
  # Since I use KeePassXC, there's no sharing built-in.
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    extraFlags = ["--no-default-folder"];
    # FIXME: Perhaps declare some stuff to sync here instead of it being only set in the Web UI?
    # I dunno about that, you already know way too much about me with this config here.
  };
}
