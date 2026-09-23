{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.template-manager;
in {
  options.programs.template-manager = {
    enable = lib.mkEnableOption "template-manager";

    package = lib.mkPackageOption pkgs "template-manager" {};

    enableNushellIntegration = lib.hm.shell.mkNushellIntegrationOption {inherit config;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    programs = {
      nushell.extraConfig =
        lib.mkIf cfg.enableNushellIntegration
        # nu
        ''
          source ${
            pkgs.runCommand "template-manager-nushell-config.nu" {} ''
              ${lib.getExe cfg.package} --generate >> "$out"
            ''
          }
        '';
    };
  };
}
