{nixpkgs ? import <nixpkgs>, ...}:

let
  fenixMonthly = builtins.fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz";
  pkgs = nixpkgs { overlays = [(import "${fenixMonthly}/overlay.nix")]; };
  lib = pkgs.lib;

  # Create the QT environment. Doing this will bundle necesarry libraries for QT build tools to
  # properly recognize libraries (since we are building a custom library for this shell)
  qtEnv = pkgs.qt6.env "quickshell-env" (with pkgs.qt6; [
    qtbase
    qtdeclarative # provides qmlls
    qtquick3d
    qtshadertools
  ]);

  mkShell = pkgs.mkShell.override {
    # Mold linker makes iterating extremely fast.
    stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.clangStdenv;
  };
in
  mkShell rec {
    packages = with pkgs; [
      qtEnv
      pkg-config
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
        "rust-analyzer"
        "rustc-codegen-cranelift-preview"
      ])
    ];

    # OpenSSL for certs only, needed by reqwest.
    # Other stuff is handled using standard lib.
    buildInputs = with pkgs; [openssl];
    env.LD_LIBRARY_PATH = toString (pkgs.lib.makeLibraryPath buildInputs);
    # Cranelift go go go
    env.CARGO_BUILD_RUSTFLAGS = "-Zcodegen-backend=cranelift";
  }
# vim: shiftwidth=2
