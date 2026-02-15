{pkgs ? import <nixpkgs> {}}: let
  # Create the QT environment. Doing this will bundle necesarry libraries for QT build tools to
  # properly recognize libraries (since we are building a custom library for this shell)
  qtEnv = pkgs.qt6.env "quickshell-env" (with pkgs.qt6; [
    qtbase
    qtdeclarative # provides qmlls
    qtquick3d
    pkgs.libglvnd
    pkgs.vulkan-headers
  ]);
in
  pkgs.mkShell.override {stdenv = pkgs.clangStdenv;} {
    packages = with pkgs; [
      qtEnv
      # Build tools to build/run the plugin.
      clang-tools
      pkg-config
      clang
      cmake
    ];

    nativeBuildInputs = with pkgs; [
      clang-tools
      makeWrapper
      openssl
    ];

    # shellHook = ''
    #   export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
    #
    #   # Add Qt-related environment variables.
    #   # https://discourse.nixos.org/t/qt-development-environment-on-a-flake-system/23707/5
    #   setQtEnvironment=$(mktemp)
    #   random=$(openssl rand -base64 20 | sed "s/[^a-zA-Z0-9]//g")
    #   makeShellWrapper "$(type -p sh)" "$setQtEnvironment" "''${qtWrapperArgs[@]}" --argv0 "$random"
    #   sed "/$random/d" -i "$setQtEnvironment"
    #   source "$setQtEnvironment"
    #
    #   # qmlls does not account for the import path and bases its search off qtbase's path.
    #   # The actual imports come from qtdeclarative. This directs qmlls to the correct imports.
    #   export QMLLS_BUILD_DIRS=$(pwd)/build:$QML2_IMPORT_PATH
    # '';
  }
# vim: shiftwidth=2

