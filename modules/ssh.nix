{pkgs, ...}: {
  # I use ssh a bi-directional channel between my PC and my laptop.
  # I rsync between them, all that stuff...
  users.users."nferhat".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq4SRZUc8RhK7kA8tFWLjdXafk1FFlMr/MNvfXYT5rI Nadjib Ferhat (nferhat@basement) <me@nferhat.dev>"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYTFpWyBxR750irFZF2ezXmZ7wKhqFiG2XtCLBMEcqN Nadjib Ferhat (nferhat@thinkpad-t14s) <me@nferhat.dev>"
  ];

  environment.systemPackages = with pkgs; [rsync sshfs];

  # Nothing special. Disabling password auth fixes most of the bullshit I could have with having port 22
  # always open on my machines.
  services.openssh = {
    enable = true;
    generateHostKeys = true;
    startWhenNeeded = true;
    settings.PasswordAuthentication = false;
  };
}
