{pkgs, ...}: {
  # How steam is managed on this device:
  #
  # The steam library lives on the windows disk (mounted above) and I add it from the Linux steam
  # install. compatdata still lives on Linux though (since proton makes use of linux fs properties
  # to make its magic work)
  programs = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    # All of these libraries are for nightly builds of Ryujinx, which I download
    # from their CI. FIXME: Make a package and whatnot, but I dont wanna build...
    nix-ld.libraries = with pkgs; [
      icu
      fontconfig
      stdenv.cc.cc.lib
      libva-utils
      libva
      pulseaudio
      libsoundio
      sndio
      vulkan-loader
      ffmpeg
      libgdiplus
      libx11
      libice
      libsm
      sdl3
      glew
      libxcursor
      libxext
      libxi
      libxrandr
      libxft
      harfbuzz
      libx11
      fontconfig
      freetype
    ];
  };
}
