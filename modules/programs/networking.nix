{pkgs, ...}: {
  # Packages used for networking stuff.
  # Nothing special. I don't want to configure any of them.
  environment.systemPackages = with pkgs; [
    rsync
    netcat
    aria2
    dnsutils
    socat
    nmap
    traceroute
  ];
}
