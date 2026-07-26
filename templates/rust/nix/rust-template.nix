{
  lib,
  inputs,
  pkgs,
  ...
}: let
  toolchain = inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.minimal.toolchain;
in
  (pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  }).buildRustPackage rec {
    pname = "rust-template";
    version = "0.1.0";

    src = builtins.path {
      path = ../.;
      name = pname;
    };

    cargoLock.lockFile = ../Cargo.lock;

    meta = {
      description = "Description";
      homepage = "https://evest.dev";
      license = lib.licenses.mit;
      mainProgram = "rust-template";
    };
  }
