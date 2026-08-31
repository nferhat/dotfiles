{
  stdenv,
  lib,
  cmake,
  pkg-config,
  vulkan-loader,
  vulkan-headers,
  qt6,
}:
stdenv.mkDerivation rec {
  pname = "lsfg-vk";
  version = "2.0.0-rc1";

  patches = [];
  src = fetchTarball {
    url = "https://git.lsfg-vk.dev/lsfg-vk/snapshot/lsfg-vk-${version}.tar.xz";
    sha256 = "0xhzgmlj5gf4hrq83k5gdqk8y39hq5zvp86068lpl0vqpfanqrpv";
  };
  cmakeFlags = ["-DLSFGVK_MANAGED=ON" "-DLSFGVK_BUILD_UI=ON"];

  postPatch = ''
    substituteInPlace lsfg-vk-layer/src/hooks.cpp \
      --replace 'this->m_extent = { info.imageExtent.width, info.imageExtent.height };' \
                'this->m_extent = vk::Extent2D{ info.imageExtent.width, info.imageExtent.height };'
  '';

  postFixup = ''
    substituteInPlace $out/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json \
      --replace '"library_path": "liblsfg-vk-layer.so"' \
                 '"library_path": "${placeholder "out"}/lib/liblsfg-vk-layer.so"'
  '';

  buildInputs = [qt6.qtbase qt6.qtdeclarative vulkan-headers vulkan-loader];
  nativeBuildInputs = [cmake pkg-config qt6.wrapQtAppsHook];

  meta = {
    homepage = "https://lsfg-vk.dev";
    platforms = lib.platforms.linux;
  };
}
