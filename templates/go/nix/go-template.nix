{buildGoApplication, ...}:
buildGoApplication rec {
  pname = "go-template";
  version = "0.1.0";

  pwd = ../.;

  src = builtins.path {
    path = ../.;
    name = pname;
  };

  modules = ../gomod2nix.toml;
}
