{
  stdenv,
  lib,
  qt6,
  cmake,
  fetchFromGitHub,
  pkg-config,
  pulseaudio,
  taglib,
}:
stdenv.mkDerivation rec {
  pname = "meloville";
  version = "1.0.5";

  patches = [
    # I know this is bad, you don't have to tell me
    ./remove-license-install.patch
  ];

  src = let
    base = fetchFromGitHub {
      owner = "NevPeth";
      repo = "meloville";
      rev = "v" + version;
      hash = "sha256-BwJQzwczesDxIPy/JOdbyPqUzxGiVUBWRxpjT1Rn0vs=";
    };
  in "${base}/src";

  buildInputs = [qt6.qtbase qt6.qtquick3d qt6.qtmultimedia taglib pulseaudio qt6.qt5compat];
  nativeBuildInputs = [cmake pkg-config qt6.wrapQtAppsHook];

  meta = {
    description = "A music player built for people who just want to listen to their music.";
    homepage = "https://github.com/NevPeth/meloville";
    changelog = "https://github.com/NevPeth/meloville/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
