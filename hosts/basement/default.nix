{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = [
      "amdgpu" # load GPU driver asap
    ];
    kernelParams = [
      "video=DP-1:2560x1440@180" # use highest mode available on boot
    ];
  };

  # Windows partition
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/B8D0936ED093321C";
    fsType = "ntfs-3g";
    options = ["rw" "uid=1000"];
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
      extraPackages = [pkgs.rocmPackages.clr.icd];
      # Thank you amd for being this nice
    };

    # Enable amvlk sine it makes some games actually run.
    # Can always reset to radv if needed.
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

  networking = {
    hostName = "basement";
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
    # Use default
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-k20n.psf.gz";
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

    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    printing.enable = true;
  };

  systemd = {
    # Add LACT for tweaking GPU configuration. We must enable ourselves since
    # there's no NixOS module yet
    packages = [pkgs.lact];
    services.lactd.wantedBy = ["multi-user.target"];
  };

  programs = {
    adb.enable = true;
    localsend.enable = true;
    nix-ld.enable = true;
    # How steam is managed on this device:
    #
    # The steam library lives on the windows disk (mounted above) and I add it from the Linux steam
    # install. compatdata still lives on Linux though (since proton makes use of linux fs properties
    # to make its magic work)
    steam = { enable = true; gamescopeSession = { enable = true; steamArgs = ["-system-composer"]; }; };
    gamemode.enable = true;
    gamescope.enable = true;
  };

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

    # Use a custom gamescope package locked to 3.14.24
    # SEE: https://github.com/ValveSoftware/gamescope/issues/1467
    gamescope = pkgs.gamescope.overrideAttrs (old: {
      version = "3.14.24";
      src = pkgs.fetchFromGitHub {
        owner = "ValveSoftware";
        repo = "gamescope";
        tag = "3.14.24";
        fetchSubmodules = true;
        hash = "sha256-+8uojnfx8V8BiYAeUsOaXTXrlcST83z6Eld7qv1oboE=";
      };
    });
  };

  users.users."nferhat".extraGroups = ["adbusers"];
  environment.systemPackages = with pkgs; [
    scrcpy
    lact
  ];

  system = {
    autoUpgrade.enable = false;
    # WARN: Do not touch, it's essential to avoid breaking when upgrading.
    stateVersion = "23.11";
  };
}
