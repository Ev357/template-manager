{
  mkShell,
  dotnet-sdk_10,
  roslyn-ls,
  csharpier,
}:
mkShell {
  packages = [
    dotnet-sdk_10
    roslyn-ls
    csharpier
  ];
}
