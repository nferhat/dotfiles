{pkgs, ...}:
# This module sets up a custom gamescope session that gives off a very similar experience
# to what starting up in the steam deck is. Very nice.
{
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

  environment.systemPackages = let
    sessionScript = pkgs.writeShellScriptBin "gamescope-session" ''
      set -xeuo pipefail
      gamescopeArgs=(
          --adaptive-sync # VRR support
          --hdr-enabled
          --mangoapp # performance overlay
          --rt
          --steam
      )
      steamArgs=(
          -pipewire-dmabuf
          -tenfoot
      )
      mangoConfig=(
          cpu_temp
          gpu_temp
          ram
          vram
      )
      mangoVars=(
          MANGOHUD=1
          MANGOHUD_CONFIG="$(IFS=,; echo "''${mangoConfig[*]}")"
      )

      export "''${mangoVars[@]}"
      # Also include additional params into gamescope
      exec gamescope "''${gamescopeArgs[@]}" "''${@}" -- steam "''${steamArgs[@]}"
    '';
  in [pkgs.mangohud sessionScript];
}
