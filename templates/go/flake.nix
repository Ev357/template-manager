{
  description = "go-template";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    gomod2nix,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      go-template = pkgs.callPackage ./nix/go-template.nix {
        inherit (gomod2nix.legacyPackages.${system}) buildGoApplication;
      };
      default = self.packages.${system}.go-template;
    });

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.callPackage ./nix/shell.nix {
        inherit (gomod2nix.legacyPackages.${system}) mkGoEnv gomod2nix;
      };
    });
  };
}
