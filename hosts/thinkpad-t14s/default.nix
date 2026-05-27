{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s
    ../shared/core.nix
    ../shared/desktop.nix
  ];

  boot = {
    # encrypted root setup.
    initrd.luks.devices."nixos-crypt" = {
      device = "/dev/disk/by-uuid/1d167ba9-c602-4029-9ff8-14477b486404";
      allowDiscards = true; # better performance on SSD
      preLVM = true; # required else it WON'T find it
    };

    loader.limine = {
      enable = true;
      secureBoot = {
        enable = true;
        autoGenerateKeys = false;
      };
      efiSupport = true;
      maxGenerations = 16;
      resolution = "2560x1440";

      style = let
        theme = import ../../theme;
        paletteColors = with theme.ansi; [color0 color1 color2 color3 color4 color5 color6 color7];
        brightPaletteColors = with theme.ansi-bright; [color8 color9 color10 color11 color12 color13 color14 color15];
        mkPallete = p: lib.concatStringsSep ";" p;
      in {
        backdrop = theme.background.primary;
        wallpapers = [theme.wallpaper];
        graphicalTerminal = {
          background = "9F${theme.background.tertiary}";
          foreground = theme.text.primary;
          margin = 30;
          brightBackground = theme.background.secondary;
          brightForeground = "FFFFFF";
          palette = mkPallete paletteColors;
          brightPalette = mkPallete brightPaletteColors;
        };
      };
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    acpilight.enable = true;

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
    networkmanager.enable = true;
    firewall.enable = false;
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

    # Battery management
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "performance";
        # Limit cpu on battery to 20% of its maximum power
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        # And try to keep the battery percentage between 40-80 when I am at home
        # Since I am always plugged to wall it can cause damage when keeping it at 100%
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };

    udev.packages = [
      pkgs.via # include udev rules for keyboard config
    ];

    # The laptop is already guarded by secure boot + full-disk encryption
    # So when we enter, might aswell autologin
    getty = {
      autologinOnce = true;
      autologinUser = "nferhat";
    };

    printing = {
      enable = true;
      drivers = [pkgs.cnijfilter2]; # for Canon PIXMA series drivers
    };

    blueman.enable = true;
    upower.enable = true;
  };

  # Works with tlp to provide power profiles
  powerManagement.enable = true;

  programs = {
    localsend.enable = true;
    steam.enable = true;
    nix-ld.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          libXcursor
          libXrandr
          libXi
          libXinerama
          libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };

  users.users."nferhat".extraGroups = ["adbusers"];
  environment.systemPackages = with pkgs; [
    scrcpy
    via
    android-tools
  ];

  system = {
    autoUpgrade.enable = false;
    # WARN: Do not touch, it's essential to avoid breaking when upgrading.
    stateVersion = "23.11";
  };
}
