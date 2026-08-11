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
    pname = "template-manager";
    version = "1.0.0";

    src = builtins.path {
      path = ../.;
      name = pname;
    };

    cargoLock.lockFile = ../Cargo.lock;

    meta = {
      description = "A small program for managing programming environment templates";
      homepage = "https://github.com/Ev357/template-manager";
      platforms = lib.systems.flakeExposed;
      license = lib.licenses.mit;
      mainProgram = "tm";
    };
  }
