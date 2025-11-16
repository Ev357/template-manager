{
  description = "haskell-template";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      ghcVersion = "98";
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          stack
          haskell.compiler."ghc${ghcVersion}"
          (haskell-language-server.override {supportedGhcVersions = [ghcVersion];})
        ];
      };
    });
  };
}
