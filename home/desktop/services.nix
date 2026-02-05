{
  pkgs,
  inputs',
  ...
}: {
  services.mpris-proxy.enable = true;

  # Services that we setup as part of the desktop/graphical session.
  # They get all triggered when fht-compositor reaches the graphical.target
  systemd.user.services = let
    start-with-graphical-session = Description: {
      Unit = {
        inherit Description;
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
        BindsTo = ["graphical-session.target"];
        Requisite = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session.target" "fht-compositor.service"];
    };
  in {
    # Quickshell, the all-in-one solution for wallpaper,  bars, and everything you can think of!
    quickshell =
      start-with-graphical-session "Quickshell service"
      // {
        Service = {
          Type = "simple";
          ExecStart = "${inputs'.quickshell.packages.default}/bin/qs";
          Restart = "on-failure";
        };
      };

    # NOTE: While yes, xwayland-satellite provides its own .servicce file, I cannot seem to make
    # it detected/started by home-manager. The configuration here just replicates it.
    xwayland-sattelite =
      start-with-graphical-session "Xwayland-satellite"
      // {
        Service = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
          StandardOutput = "jounral";
        };
      };
  };
}
