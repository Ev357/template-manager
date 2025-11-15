{
  lib,
  inputs,
  pkgs,
  system,
  ...
}: let
  toolchain = inputs.fenix.packages.${system}.minimal.toolchain;
in
  (pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  }).buildRustPackage rec {
    pname = "template-manager";
    version = "0.1.0";

    src = builtins.path {
      path = ../.;
      name = pname;
    };

    cargoLock.lockFile = ../Cargo.lock;

    meta = {
      description = "A small program for managing programming environment templates";
      homepage = "https://github.com/Ev357/template-manager";
      license = lib.licenses.mit;
      mainProgram = "tm";
    };
  }
