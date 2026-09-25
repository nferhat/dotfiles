{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./home.nix
    ./games.nix
    ../../modules/desktop
    ../../modules/limine.nix
    ../../modules/core.nix
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

    kernelPackages = pkgs.linuxPackages_latest;

    initrd.kernelModules = [
      "amdgpu" # load GPU driver asap
      "i2c-dev"
    ];
    kernelParams = [
      "video=DP-1:2560x1440@180" # use highest mode available on boot
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

  # For tuning my GPU. LACT provides an alternative to Adrenalin software from
  # windows. However you have to enable override separately (with a kernel param)
  hardware.amdgpu.overdrive.enable = true;
  services.lact.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    xone.enable = true; # Xbox360 with USB dongle
    amdgpu.opencl.enable = true; # for blender.

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [pkgs.rocmPackages.clr.icd];
      # Thank you amd for being this nice
    };
  };

  console = { earlySetup = true; keyMap = "us"; };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };

    ratbagd.enable = true;
    printing.enable = true;
  };

  # Enable support for ROCm/HIP, AMD's equivalent to CUDA.
  # FIXME: Also figure out how to get Zluda working
  nixpkgs.config.rocmSupport = true;

  environment.systemPackages = with pkgs; [
    piper # configuring my logitech g502 hero
    self.packages.${pkgs.system}.lsfg-vk # framegen woo
  ];

  system = {
    autoUpgrade.enable = false;
    # WARN: Do not touch, it's essential to avoid breaking when upgrading.
    stateVersion = "23.11";
  };
}
