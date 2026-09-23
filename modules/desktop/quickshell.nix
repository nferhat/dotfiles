{
  pkgs,
  inputs,
  ...
}: {
  nferhat.packages = [
    inputs.quickshell.packages."${pkgs.system}".default
    # Thank you Ardox for this amazing plugin!
    # Saved me a bunch of headaches.
    inputs.fht-compositor-qml-plugin.packages."${pkgs.system}".default
  ];

  # Spawn Quickshell with systemd. This provides multiple advantages other fhtc's autostart.
  #
  # - Restart=on-failure auto restarts the shell if it crashed for some reason (this notably happens
  #   with the wlr-screencopy/cast/whatever widget. Dunno when they will fix it.
  #
  # - By binding to After fht-compositor has been marked as ready, we make sure that the
  #   $FHTC_IPC_SOCKET is set and imported to systemd's user env. fht-compositor-qml-plugin doesn't
  #   have a reconnection mechanism (yet)
  nferhat.systemd.user.services."quickshell" = {
    Unit = {
      Description = "Quickshell Shell";
      PartOf = ["graphical-session.target"];
      Requisite = ["graphical-session.target"];
      After = ["fht-compositor.service"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${inputs.quickshell.packages.${pkgs.system}.default}/bin/qs";
      Restart = "on-failure";
    };

    Install.WantedBy = ["fht-compositor.service"];
  };
}
