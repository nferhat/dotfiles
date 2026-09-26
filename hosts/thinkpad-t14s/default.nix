{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s
    ./power.nix
    ../../modules/desktop
    ../../modules/limine.nix
    ../../modules/core.nix
  ];

  boot = {
    # encrypted root setup.
    initrd.luks.devices."nixos-crypt" = {
      device = "/dev/disk/by-uuid/1d167ba9-c602-4029-9ff8-14477b486404";
      allowDiscards = true; # better performance on SSD
      preLVM = true; # required else it WON'T find it
    };

    loader.limine.resolution = "1920x1080";
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

  # earlySetup here is needed since I have to type my FDE password on boot
  # so the initramfs needs to have a console ready and working.
  console = {
    earlySetup = true;
    # I don't mind a nice font you know.
    font = "${pkgs.terminus_font}/share/consolefonts/ter-k20n.psf.gz";
    keyMap = "us";
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # The laptop is already guarded by secure boot + full-disk encryption
    # So when we enter, might aswell autologin
    getty = {
      autologinOnce = true;
      autologinUser = "nferhat";
    };

    printing.enable = true;
    blueman.enable = true; # bluetooth manager.
    displayManager.ly.enable = false;
  };

  # acpilight already sets up udev rules for the video group to access /sys/class/backlight/
  # Adding this lets me use the `xbacklight` cli without sudo.
  users.users."nferhat".extraGroups = ["video"];

  system = {
    autoUpgrade.enable = false;
    # WARN: Do not touch, it's essential to avoid breaking when upgrading.
    stateVersion = "23.11";
  };
}
