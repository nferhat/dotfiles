{...}: {
  services = {
    ssh-agent.enable = true;

    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      defaultCacheTtl = 600; # validate for 10 minutes.
      pinentryFlavor = "gtk2";
    };
  };
}
