{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  breeze-icons,
  hicolor-icon-theme,
  gitUpdater,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Kaze";
  version = "25.08";

  src = fetchFromGitHub {
    owner = "0hStormy";
    repo = pname;
    rev = version;
    hash = "sha256-c6VbhH27Px2yKCN1xdChzoM5c4YNOXH2np5tarKuTYM=";
  };

  nativeBuildInputs = [gtk3];
  propagatedBuildInputs = [breeze-icons hicolor-icon-theme];
  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    theme_dir=$out/share/icons/Kaze
    mkdir -p $theme_dir
    mv index.theme 16x16 22x22 32x32 48x48 64x64 96x96 128x128 $theme_dir
    gtk-update-icon-cache --force $theme_dir

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {};

  meta = with lib; {
    description = "A smooth, modern icon set for Linux";
    homepage = "https://github.com/0hStormy/Kaze";
    license = licenses.cc-by-sa-40;
    platform = platforms.linux;
  };
}
