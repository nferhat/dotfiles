{inputs', ...}:
# Quickshell is the shell I build my desktop UI on.
# Written in QT its really good.
{
  home.packages = [inputs'.quickshell.packages.default];
}
