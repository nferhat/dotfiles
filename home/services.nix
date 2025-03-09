{pkgs, ...}: {
  services = {
    ssh-agent.enable = true;

    gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      defaultCacheTtl = 600; # validate for 10 minutes.
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    gnome-keyring.enable = true;
  };
}
