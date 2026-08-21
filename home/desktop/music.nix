{
  pkgs,
  self,
  ...
}:
# Music setup. Nothing particularly special about this.
# Amberol is fine, but I wanna write my mpd client at some point...
{
  home.packages = with pkgs; [
    self.packages."${pkgs.system}".meloville
    picard
  ];
}
