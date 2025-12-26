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
  pname = "Arashi";
  version = "09a553b911599fe906fe949aa290d8fd68533a89";

  src = fetchFromGitHub {
    owner = "0hStormy";
    repo = pname;
    rev = version;
    hash = "sha256-9Dh+cvneeSQtiDi7fnDCSqlaTS4I9pmAooUsbb+D5X8=";
  };

  nativeBuildInputs = [gtk3];
  propagatedBuildInputs = [breeze-icons hicolor-icon-theme];
  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    theme_dir=$out/share/icons/${pname}
    mkdir -p $theme_dir
    mv scalable $theme_dir
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
