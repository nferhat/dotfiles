{
  pkgs,
  config,
  ...
}:
# scrcpy.nix -*- Setup scrcpy, a tool that allows you to either screencopy your phone's screen, or use
# it's camera as a video source. It can even integrate with Video4Linux, allowing me to use my
# phone as an ad-hoc camera in apps
{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    kernelModules = ["v4l2loopback"];
    # Create two cams, one for scrcpy and one for obs-vc.
    # You cant specify a modprobe config twice soooooooooo
    extraModprobeConfig = ''
      options v4l2loopback devices=2 video_nr=1,2 card_label="scrcpy","obs-vc" exclusive_caps=1,1
    '';
  };

  # adbusers to use ADB without root, and video to access /dev/videoX
  users.users."nferhat".extraGroups = ["adbusers" "video"];
  environment.systemPackages = with pkgs; [android-tools scrcpy];
}
