{
  description = "Template manager";

  nixConfig = {
    extra-substituters = [
      "https://ev357.cachix.org"
      "https://fenix.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "ev357.cachix.org-1:bI65rULXWJ8IMM+tosc/Z+9W53nL6uj4+5FLXX6BN3Q="
      "fenix.cachix.org-1:ecJhr+RdYEdcVgUkjruiYhjbBloIEGov7bos90cZi0Q="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    crane.url = "github:ipetkov/crane";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    crane,
    fenix,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

    mkPerSystem = perSystem:
      forAllSystems (system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
            fenix.overlays.default
          ];
        };

        craneLib = (crane.mkLib pkgs).overrideToolchain fenix.packages.${system}.default.toolchain;
      in
        perSystem {inherit pkgs craneLib system;});
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = mkPerSystem ({
      pkgs,
      craneLib,
      system,
    }: {
      template-manager = pkgs.callPackage ./nix/template-manager.nix {inherit craneLib;};
      default = self.packages.${system}.template-manager;
    });

    devShells = mkPerSystem ({
      pkgs,
      craneLib,
      ...
    }: {
      default = pkgs.callPackage ./nix/shell.nix {inherit craneLib;};
    });

    overlays = {
      template-manager = final: _: let
        system = final.stdenv.hostPlatform.system;
      in {
        template-manager = self.packages.${system}.template-manager;
      };
      default = self.overlays.template-manager;
    };

    homeModules = {
      template-manager = {
        imports = [./nix/home-manager.nix];
        nixpkgs.overlays = [self.overlays.default];
      };
      default = self.homeModules.template-manager;
    };
  };
}
