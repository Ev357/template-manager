{
  lib,
  craneLib,
}: let
  cargoToml = fromTOML (builtins.readFile ../Cargo.toml);

  commonArgs = {
    pname = "template-manager";
    version = cargoToml.workspace.package.version;

    src = craneLib.cleanCargoSource ../.;

    strictDeps = true;
  };

  cargoArtifacts = craneLib.buildDepsOnly commonArgs;
in
  craneLib.buildPackage (
    commonArgs
    // {
      inherit cargoArtifacts;

      meta = {
        description = cargoToml.workspace.package.description;
        homepage = cargoToml.workspace.package.repository;
        platforms = lib.systems.flakeExposed;
        license = lib.licenses.mit;
        mainProgram = "tm";
      };
    }
  )
