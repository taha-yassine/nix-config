{
  den.aspects.terminal.homeManager =
    {
      config,
      lib,
      pkgs,
      pkgs-unstable,
      ...
    }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = with pkgs-unstable; [
        wl-clipboard
      ];

      home.shellAliases = {
        update = "sudo nixos-rebuild switch";
        rebuild = "nh os switch $HOME/nix-config -H $(hostname)";
        hm-rebuild = "nh home switch -c ${config.home.username}@$(hostname) $HOME/nix-config";
      };

      programs.btop.package = pkgs-unstable.btop.override {
        cudaSupport = true;
        rocmSupport = true;
      };

      programs.kitty = {
        enable = true;
        themeFile = "Molokai";
        settings.wayland_titlebar_color = "system";
      };

      programs.ghostty = {
        enable = true;
        enableFishIntegration = true;
        package = pkgs-unstable.ghostty;
        settings = {
          theme = "dark:Monokai Remastered,light:Adwaita";
          keybind = [
            "ctrl+shift+w=close_surface"
            "global:super+shift+Q=toggle_quick_terminal"
          ];
        };
      };

      xdg.terminal-exec = {
        enable = true;
        settings.default = [ "com.mitchellh.ghostty.desktop" ];
      };
    };
}
