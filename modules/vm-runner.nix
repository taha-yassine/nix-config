{ inputs, ... }:
{
  perSystem = { pkgs, ... }: {
    packages.vm = pkgs.writeShellApplication {
      name = "vm";
      text = ''
        ${inputs.self.nixosConfigurations.framework.config.system.build.vm}/bin/run-framework-vm "$@"
      '';
    };
  };
}
