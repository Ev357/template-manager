{
  description = "rust-template";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    fenix,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      rust-template = pkgs.callPackage ./nix/rust-template.nix {inherit inputs;};
      default = self.packages.${system}.rust-template;
    });

    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [fenix.overlays.default];
      };
    in {
      default = pkgs.callPackage ./nix/shell.nix {inherit inputs;};
    });
  };
}
