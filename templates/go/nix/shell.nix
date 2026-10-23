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

  shellHook =
    # bash
    ''
      export GOPATH="''${XDG_DATA_HOME:-$HOME/.local/share}/go"
      export PATH="$GOPATH/bin:$PATH"
    '';
}
