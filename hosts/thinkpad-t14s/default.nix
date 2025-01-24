{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    # encrypted root setup.
    initrd.luks.devices."nixos-crypt" = {
      device = "/dev/disk/by-uuid/1d167ba9-c602-4029-9ff8-14477b486404";
      allowDiscards = true; # better performance on SSD
      preLVM = true; # required else it WON'T find it
    };

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    cpu.amd.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      # Thank you amd for being this nice
    };
  };

  networking = {
    hostName = "thinkpad-t14s";
    wireless.enable = false;
    networkmanager.enable = true;
    firewall.enable = false;

    # For whatever reason, my laptop can't resolve most domains without cloudflare+resolved combo
    # Go figure out why.
    nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
  };

  # No thank you, this will just consume time trying to connect any present card instead of actually
  # letting the system boot
  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "Africa/Algiers";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-k20n.psf.gz";
    keyMap = "us";
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."];
      fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };

    blueman.enable = true;
    printing.enable = true;
    upower.enable = true;
  };

  programs = {
    light.enable = true; # can't control directly using kernel+hotkeys.
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    steam-run
    gamescope
    steamcmd
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };

  system = {
    autoUpgrade.enable = false;
    # WARN: Do not touch, it's essential to avoid breaking when upgrading.
    stateVersion = "23.11";
  };
}
