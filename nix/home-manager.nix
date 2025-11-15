{self, ...}: {
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.template-manager;
in {
  options.programs.template-manager = {
    enable = lib.mkEnableOption "template-manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.template-manager;
      description = "The package to use";
    };

    enableNushellIntegration = lib.hm.shell.mkNushellIntegrationOption {inherit config;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    programs = let
      nushellIntegration =
        # nu
        ''
          source ${
            pkgs.runCommand "template-manager-nushell-config.nu" {} ''
              ${lib.getExe cfg.package} --generate >> "$out"
            ''
          }
        '';
    in {
      nushell.extraConfig = lib.mkIf cfg.enableNushellIntegration nushellIntegration;
    };
  };
}
