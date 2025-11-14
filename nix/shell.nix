{
  pkgs,
  inputs,
  ...
}:
pkgs.mkShell {
  buildInputs = with pkgs.extend inputs.fenix.overlays.default; [
    inputs.fenix.packages.${system}.default.toolchain
    rust-analyzer-nightly
  ];
}
