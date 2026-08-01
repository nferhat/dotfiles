
{
  lib,
  stdenvNoCC,
  fetchFromForgejo,
  gitUpdater,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Arashi";
  version = "e6cbae43d57d4fa6a096b7bd0e9ed35d2f45d528";

  src = fetchFromForgejo {
    domain = "git.0stormy.xyz";
    owner = "stormy";
    repo = pname;
    rev = version;
    hash = "sha256-IFty5+zgD/cAWMOubsD5iuiw3+oRlx9kIwHkuR8nzsA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/${pname}
    cp -r . $out/share/icons/${pname}/

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {};

  meta = with lib; {
    description = "A smooth, modern icon set for Linux";
    homepage = "https://git.0stormy.xyz/stormy/Arashi";
    license = licenses.cc-by-sa-40;
    platform = platforms.all;
  };
}
