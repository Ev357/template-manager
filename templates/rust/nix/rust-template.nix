{
  lib,
  pkgs,
  inputs,
  ...
}: let
  toolchain = inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.default.toolchain;
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
      platforms = lib.systems.flakeExposed;
      license = lib.licenses.mit;
      mainProgram = "rust-template";
    };
  }
