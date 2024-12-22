{pkgs, ...}: {
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
    wallpaper =
      start-with-graphical-session "Wallpaper service"
      // {
        Service = {
          Type = "simple";
          ExecStart = let
            theme = import ../../theme;
            inherit (theme) wallpaper;
          in "${pkgs.swaybg}/bin/swaybg -i ${wallpaper}";
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
