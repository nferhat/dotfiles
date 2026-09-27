{pkgs, ...}: {
  # Configuring power for a laptop is fucking hell.
  #
  # As a student, I use my laptop to take notes and attend work sessions.
  # So, logically, I want to squeeze out as much uptime as possible without having
  # to resort to a power brick.
  powerManagement.enable = true;
  services.upower.enable = true;
  environment.systemPackages = with pkgs; [acpi];

  # Hitting the power key should suspend the laptop. Not power down.
  # FIXME: Lock the session when this happens zzz
  services.logind.settings.Login.HandlePowerKey = "suspend";
  # Use s2idle instead of deep sleep/suspend-to-ram.
  # Allows for crazy fast boot timrs.
  systemd.sleep.settings.Sleep.MemorySleepMode = "s2idle";

  # tlp has sensible defaults and I configure it further t
  services.tlp.enable = true;
  services.tlp.pd.enable = true; # provide power-profiles-daemon interface
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    # No limits on AC. This means I'm home. If I'm outside and need a quick charge
    # I can do tlp bat to limit power.
    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    # Limit cpu on battery to 30% of its maximum power on battery. Even with this
    # battery life is lacking. Fucking amd64/x86_64, why can't you be efficient!
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 30;

    # Avoid overcharge of the battery. Since at home I keep it plugged in all
    # night, this avoids tiring it out
    START_CHARGE_THRESH_BAT0 = 0;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

  # remove the need to type the password zzzz
  security.sudo.extraRules = [
    {
      users = ["nferhat"];
      commands = [
        {
          command = "/run/current-system/sw/bin/tlp";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/tlp-stat";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
