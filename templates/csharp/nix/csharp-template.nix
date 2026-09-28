{
  buildDotnetModule,
  dotnetCorePackages,
}:
buildDotnetModule rec {
  pname = "csharp-template";
  version = "0.1.0";

  src = builtins.path {
    path = ../.;
    name = pname;
  };

  projectFile = "${pname}.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
}
