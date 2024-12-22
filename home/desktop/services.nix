{pkgs, ...}: {
  # Services that we setup as part of the desktop/graphical session.
  # They get all triggered when fht-compositor reaches the graphical.target
  systemd.user.services = let
    start-with-graphical-session = description: {
      Unit = {
        inherit description;
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Install.WantedBy = ["fht-compositor.service"];
    };
  in {
    wallpaper = start-with-graphical-session "Wallpaper service" // {
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${./wallpaper.png}";
        Restart = "on-failure";
      };
    };
  };
}
