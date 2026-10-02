{config, ...}: {
  # Guess what, I want to access my devices over the net.
  # Tailscales sovles this, even with a free tier.
  services.tailscale = {
    enable = true;
  };

  # Apparently its better to use nftables.
  # iptables is "legacy" or whatever, but I guess im picking the modern one.
  networking.nftables.enable = true;
  networking.firewall = {
    trustedInterfaces = [config.services.tailscale.interfaceName];
    allowedUDPPorts= [config.services.tailscale.port];
  };

  # Without this it might fallback to other stuff.
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  # FIXME: For now SSL certs have to be done manually.
  # Maybe automating them would be worth it. idk
}
