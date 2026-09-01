{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  remarshal,
  ttfautohint-nox,
}:
# This is a REALLY stripped down version of the iosevka derivation
# I don't need all the bells and whistles for confi
buildNpmPackage rec {
  pname = "FhtMono";
  version = "34.8.1";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${version}";
    hash = "sha256-1uczmW/DwSGXRXNob76AEHFcMPnodEiI9DzI8KSFJ8w=";
  };

  npmDepsHash = "sha256-0+v+bMNL1QWuMRk3rQu8PRSeNJ459JVVhvnG1qlvty4=";
  nativeBuildInputs = [remarshal ttfautohint-nox];

  configurePhase = ''
    runHook preConfigure
    cp "${./build-plan.toml}" private-build-plans.toml
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild

    # pipe to cat to disable progress bar
    # 32 cores is fine for me.
    npm run build --no-update-notifier --targets ttf::$pname -- --jCmd=32 --verbosity=9 | cat

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    fontdir="$out/share/fonts/truetype"
    install -d "$fontdir"
    install "dist/$pname/TTF"/* "$fontdir"
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://typeof.net/Iosevka/";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = "Versatile typeface for code, from code";
    longDescription = ''
      Iosevka is an open-source, sans-serif + slab-serif, monospace +
      quasi‑proportional typeface family, designed for writing code, using in
      terminals, and preparing technical documents.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
