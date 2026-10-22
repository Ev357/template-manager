{
  mkShell,
  mkGoEnv,
  gomod2nix,
  golangci-lint,
}:
mkShell {
  packages = let
    goEnv = mkGoEnv {pwd = ../.;};
  in [
    goEnv
    gomod2nix
    golangci-lint
  ];
}
