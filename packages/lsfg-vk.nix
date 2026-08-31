{
  stdenv,
  lsfg-vk-src,
  version,
  lib,
  cmake,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "lsfg-vk-cli";
  inherit version;

  patches = [];
  src = "${lsfg-vk-src}/lsfg-vk-cli";
  cmakeFlags = ["-DCMAKE_BUILD_TYPE=Release"];

  buildInputs = [];
  nativeBuildInputs = [cmake pkg-config];

  meta = {
    homepage = "https://lsfg-vk.dev";
    platforms = lib.platforms.linux;
  };
}
