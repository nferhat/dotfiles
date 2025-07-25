{pkgs, ...}: {
  services = {
    ssh-agent.enable = true;

    gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      defaultCacheTtl = 600; # validate for 10 minutes.
      pinentry.package = pkgs.pinentry-qt;
    };

    gnome-keyring.enable = true;
  };
}
