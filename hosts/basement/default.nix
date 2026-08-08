{
  pkgs,
  self',
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../shared/core.nix
    ../shared/desktop.nix
    ../shared/limine.nix
  ];

  boot = {
    loader.limine = {
      resolution = "2560x1440";
      # Chainloading my windows 11 system
      extraEntries = ''
        /Windows 11
          protocol: efi_chainload
          path: uuid(6657baf6-2098-404f-87c8-4086fc3a843c):/EFI/Microsoft/Boot/bootmgfw.efi
          resolution: 2560x1440x32
      '';
    };

    initrd.kernelModules = [
      "amdgpu" # load GPU driver asap
    ];
    kernelParams = [
      "video=DP-1:2560x1440@180" # use highest mode available on boot
      "amdgpu.ppfeaturemask=0xffffffff" # enable control with LACT
      "clearcpuid=umip" # if you know, you know.
    ];
  };

  # Windows partition setup.
  #
  # For some reason after a while windows decided to turn its partition into a Bitlocker partition
  # And there's no hope out of this, so we do a convoluted setup to acutally mount it.
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/B8D0936ED093321C";
    fsType = "ntfs-3g";
    options = ["rw" "uid=1000" "optional" "comment=x-gvfs-show"];
  };

  hardware = {
    enableRedistributableFirmware = true;
    xone.enable = true; # Xbox360 with USB dongle
    amdgpu.opencl.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
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
    ratbagd.enable = true;
    lact.enable = true;

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
  };

  programs = {
    localsend.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [icu];
    };
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

    appimage = {
      enable = true;
      package = pkgs.appimage-run.override {extraPkgs = pkgs: [pkgs.icu];};
    };
  };

  users.users."nferhat".extraGroups = [
    "adbusers" # for android debug bridge
  ];

  environment.systemPackages = with pkgs; [
    scrcpy
    self'.packages.lsfg-vk
    lact
    android-tools
  ];

  system = {
    autoUpgrade.enable = false;
    # WARN: Do not touch, it's essential to avoid breaking when upgrading.
    stateVersion = "23.11";
  };
}
