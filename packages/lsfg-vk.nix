{
  lib,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  llvmPackages,
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "lsfg-vk";
  version = "9943153918b50804338adfbc719793be3546f954";

  src = fetchFromGitHub {
    owner = "PancakeTAS";
    repo = "lsfg-vk";
    rev = "${version}";
    hash = "sha256-bU1+EWKkdTwqvP8INkd13SPKEmXuEeK1q76Q8qwQV68=";
    fetchSubmodules = true;
  };

  postInstall = ''
    substituteInPlace $out/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json \
      --replace-fail "liblsfg-vk-layer.so" "$out/lib/liblsfg-vk-layer.so"
  '';

  nativeBuildInputs = [
    llvmPackages.clang-tools
    llvmPackages.libllvm
    cmake
  ];

  buildInputs = [
    vulkan-headers
  ];

  meta = {
    description = "Vulkan layer for frame generation (Requires owning Lossless Scaling)";
    homepage = "https://github.com/PancakeTAS/lsfg-vk/";
    changelog = "https://github.com/PancakeTAS/lsfg-vk/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pabloaul ];
  };
}
