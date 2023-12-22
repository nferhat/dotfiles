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
      device = "/dev/disk/by-uuid/03d2aedd-f80b-4d19-877e-a6f37a67b941";
      allowDiscards = true; # better performance on SSD
      preLVM = true; # required else it WON'T find it
    };

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        gfxmodeEfi = "1024x768"; # grub is slow so lower the resolution of the menu.
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

    cpu.intel.updateMicrocode = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [intel-compute-runtime intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl];
      extraPackages32 = with pkgs.pkgsi686Linux; [intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl];
    };
  };

  networking = {
    hostName = "hp-da0018nk";
    wireless.enable = false;
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
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    blueman.enable = true;
    printing.enable = true;
    upower.enable = true;
  };

  programs = {
    light.enable = true; # can't control directly using kernel+hotkeys.
  };

  system = {
    autoUpgrade.enable = false;
    # WARN: Do not touch, it's essential to avoid breaking when upgrading.
    stateVersion = "23.11";
  };
}
