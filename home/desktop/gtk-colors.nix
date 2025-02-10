# List of GTK colors, as per the libadwaita default stylesheet
# I use libadwaita for the general UI of my rice, with a custom color scheme.
{
  theme,
  opacity,
  ...
}: with theme; rec {
  accent_color = accent;
  accent_bg_color = accent + opacity;
  accent_fg_color = background.secondary;

  window_bg_color = background.primary + opacity;
  window_fg_color = text.primary;

  headerbar_bg_color = background.tertiary + opacity;
  headerbar_fg_color = text.secondary;

  popover_bg_color = background.tertiary;
  popover_fg_color = ansi-bright.color15;
  dialog_bg_color = popover_bg_color + opacity;
  dialog_fg_color = popover_fg_color;

  sidebar_bg_color = background.primary + opacity;
  sidebar_fg_color = text.primary;
  sidebar_backdrop_color = background.primary + opacity;
  sidebar_shade_color = "0000007f";
  sidebar_border_color = separator;

  secondary_sidebar_bg_color = sidebar_bg_color;
  secondary_sidebar_fg_color = sidebar_fg_color;
  secondary_sidebar_backdrop_color = sidebar_backdrop_color;
  secondary_sidebar_shade_color = sidebar_shade_color;
  secondary_sidebar_border_color = sidebar_border_color;

  view_bg_color = ansi-bright.color8 + opacity;
  view_fg_color = window_fg_color;

  card_bg_color = ansi-bright.color8;
  card_fg_color = text.primary;

  thumbnail_bg_color = background.secondary + opacity;
  thumbnail_fg_color = text.primary;

  warning_bg_color = warning + opacity;
  warning_fg_color = text.secondary;
  warning_color = warning;

  error_bg_color = error + opacity;
  error_color = error;
  error_fg_color = text.secondary;

  success_bg_color = ansi.color2 + opacity;
  success_color = ansi.color2;
  success_fg_color = text.secondary;

  destructive_bg_color = ansi-bright.color9 + opacity;
  destructive_fg_color = ansi-bright.color8;
  destructive_color = ansi-bright.color9;
}
