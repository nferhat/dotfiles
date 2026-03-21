# Browser configuration.
{
  config,
  inputs,
  ...
}: {
  # The zen-browser flake uses mkFirefoxModule, so everything inside programs.firefox or
  # programs.librewolf is available for us to mess with.
  programs.librewolf = {
    enable = true;

    # Two profiles
    # - "nferhat": Where I do all my regular stuff
    # - "streamer": Has my nferhat's dev channel and no other accounts
    profiles = let
      settings = import ./user-prefs.nix;
    in {
      nferhat = {
        inherit settings;
        id = 0;
      };
      streamer = {
        inherit settings;
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
