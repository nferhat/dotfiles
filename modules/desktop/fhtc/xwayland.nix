{pkgs, ...}: {
  # Since fhtc doesn't have native Xwayland built in (yet), xwayland-satellite provides an
  # excellent alternative that suits and fills all my needs.
  nferhat.systemd.user.services."xwayland-satellite" = {
    Unit = {
      Description = "Xwayland outside your Wayland";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
      Requisite = ["graphical-session.target"];
    };

    # Copied from the official .service file.
    # <https://github.com/Supreeeme/xwayland-satellite/blob/main/resources/xwayland-satellite.service>
    Service = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      StandardOutput = "jounral";
      Restart = "on-failure";
    };

    Install.WantedBy = ["graphical-session.target"];
  };
}
