{
  pkgs,
  inputs,
  ...
}:
pkgs.mkShell {
  buildInputs = with pkgs.extend inputs.fenix.overlays.default; [
    inputs.fenix.packages.${stdenv.hostPlatform.system}.default.toolchain
    rust-analyzer-nightly
  ];
}
