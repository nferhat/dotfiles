{
  pkgs,
  self',
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./secure-boot.nix
    ../shared/core.nix
    ../shared/desktop.nix
  ];

  boot = {
    loader = {
      # grub = {
      #   enable = true;
      #   device = "nodev";
      #   efiSupport = true;
      #   useOSProber = true;
      # };
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = [
      "amdgpu" # load GPU driver asap
    ];
    kernelParams = [
      "video=DP-1:2560x1440@180" # use highest mode available on boot
      # "amdgpu.ppfeaturemask=0xffffffff" # enable control with LACT
    ];
  };

  # Windows partition setup.
  #
  # For some reason after a while windows decided to turn its partition into a Bitlocker partition
  # And there's no hope out of this, so we do a convoluted setup to acutally mount it.
  fileSystems."/mnt/windows" = {
    device = "/mnt/dislocker/dislocker-file";
    fsType = "ntfs-3g";
    options = ["rw" "uid=1000" "optional" "comment=x-gvfs-show"];
  };
  # The bitlocker service that basically runs dislocker to mount/opens the bitlocker drive.
  systemd.services.dislocker-bitlocker = {
    description = "Unlock Windows C:\ BitLocker drive";
    wantedBy = [ "multi-user.target" ];
    before = [ "mnt-windows.mount" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.dislocker}/bin/dislocker \
          -V /dev/disk/by-uuid/addd4d15-1def-4eb4-8d67-9d5a04791eb4 \
          -- /mnt/dislocker
      '';
      ExecStop = "fusermount -u /mnt/dislocker";
      RemainAfterExit = true;
    };
  };
  # Don't forget to cleanup the dislocker mount
  systemd.tmpfiles.rules = [
    "d /mnt/dislocker 0755 root root -"
  ];

  hardware = {
    enableRedistributableFirmware = true;
    xone.enable = true; # Xbox360 with USB dongle
    amdgpu.opencl.enable = true;

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

    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = ["nferhat"]; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no";
      };
    };

    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };

    printing.enable = true;
    flatpak.enable = true;
  };


  programs = {
    virt-manager.enable = true;
    localsend.enable = true;
    nix-ld.enable = true;
    appimage.enable = true;
    gpu-screen-recorder.enable = true;
    # How steam is managed on this device:
    #
    # The steam library lives on the windows disk (mounted above) and I add it from the Linux steam
    # install. compatdata still lives on Linux though (since proton makes use of linux fs properties
    # to make its magic work)
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        steamArgs = ["-system-composer"];
      };
    };
    gamemode.enable = true;
    gamescope.enable = true;
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

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  users.users."nferhat".extraGroups = ["adbusers" "libvirtd"];
  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk
    scrcpy
    # For tuning the 7900XT properly.
    # lact
    # Framegeneration since it looks good with Ryujinx.
    self'.packages.lsfg-vk
    # Making use of this.
    android-tools
    # Windows drive
    dislocker
  ];
  environment.etc."vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json".source = "${self'.packages.lsfg-vk}/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json";

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  system = {
    autoUpgrade.enable = false;
    # WARN: Do not touch, it's essential to avoid breaking when upgrading.
    stateVersion = "23.11";
  };
}
