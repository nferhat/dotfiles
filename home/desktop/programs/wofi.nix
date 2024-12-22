{...}: {
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun"; # Basically the defacto.
      width = 600;
      height = 300;
      prompt = "What do you wanna launch?";
      allow_images = true;
      allow_markup = true;
      term = "wezterm";
      hide_scroll = true;
      matching = "fuzzy";
      insensitive = true;
      columns = 1;
      lines = 8;
      line_wrap = "word_char";
      content_halign = "start";
      valign = "start";
      # Display the generic name like
      # "Web browser" or "Photo Viewer"
      drun-display_generic = true;
    };
  };
}
