{ self, pkgs, ... }: {
  # This forwards controls from my bluetooth earbuds (like play/pause) to MPRIS players.
  nferhat.services.mpris-proxy.enable = true;
  # Music setup. Nothing particularly special about this.
  # Meloville is an amazing player that does its job.
  nferhat.packages = with pkgs; [
    self.packages."${pkgs.system}".meloville
    picard
  ];

  # FIXME: Sync music library between devices?
}
