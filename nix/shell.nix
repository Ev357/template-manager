{
  pkgs,
  lib,
  inputs,
  ...
}:
pkgs.mkShell {
  buildInputs = with pkgs.extend inputs.fenix.overlays.default; [
    inputs.fenix.packages.${stdenv.hostPlatform.system}.default.toolchain
    rust-analyzer-nightly
    pkg-config
    openssl
  ];

  env = {
    LD_LIBRARY_PATH = lib.makeLibraryPath (with pkgs; [
      openssl
    ]);
  };
}
