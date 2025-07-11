# Browser configuration.
# ---
# Configure and (somewhat) theme Zen Browser.
#
# In the past I used to only use LibreWolf, but with time I found out that having some of the
# niceties that Zen provides is really really nice, and I am enjoying it quite a lot.
{
  config,
  inputs,
  ...
}: {
  imports = [inputs.zen-browser.homeModules.twilight];
  # The zen-browser flake uses mkFirefoxModule, so everything inside programs.firefox or
  # programs.librewolf is available for us to mess with.
  programs.zen-browser = {
    enable = true;

    # Two profiles
    # - "nferhat": Where I do all my regular stuff
    # - "streamer": Has my nferhat's dev channel and no other accounts
    profiles = let
      user-prefs = import ./user-prefs.nix;
      theme = import ../../../../theme;
      # Slightly less border radius so that Zed's corners match the border's inner side
      inherit (config.programs.fht-compositor.settings) decorations;
      innerRadius = decorations.border.radius - decorations.border.thickness;
      settings = user-prefs {cornerRadius = innerRadius;};

      # Make Zen's background match the theme.
      # FIXME: This doesn't seem to work when `zen.widget.linux.transparency` is set to true
      userChrome = ''
        main-window, :root {
          --zen-main-browser-background: #${theme.background.primary}e7 !important;
          --zen-navigator-toolbox-background: #${theme.background.tertiary} !important;
        }
        /* Disable shadow */
        hbox.browserSidebarContainer,
        #zen-tabbox-wrapper {
          box-shadow: none !important;
        }

        /* Remove highlight from "content area" */
        :root:not([inDOMFullscreen="true"]):not([chromehidden~="location"]):not([chromehidden~="toolbar"]) {
          & #tabbrowser-tabbox #tabbrowser-tabpanels .browserSidebarContainer {
            & browser[transparent="true"] {
              background: none !important;
            }
          }
        }
      '';
    in {
      nferhat = {
        inherit userChrome settings;
        id = 0;
      };
      streamer = {
        inherit userChrome settings;
        id = 1;
        bookmarks.force = true; # override whatever, not like this profile will be used actively
        bookmarks.settings = [
          {
            name = "YouTube";
            tags = ["youtube"];
            keyword = "yt";
            url = "https://youtube.com";
          }
          {
            name = "YouTube studio";
            tags = ["youtube" "youtube-studio" "streaming"];
            keyword = "yts";
            url = "https://studio.youtube.com";
          }
          "separator"
          {
            name = "GitHub";
            tags = ["github" "code"];
            keyword = "gh";
            url = "https://github.com";  
          }
          {
            name = "My GitHub";
            tags = ["github" "code" "personal"];
            url = "https://github.com/nferhat";  
          }
        ];
      };
    };
  };
}
