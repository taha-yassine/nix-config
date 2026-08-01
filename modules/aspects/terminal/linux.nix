{
  den.aspects.terminal.homeManager =
    {
      host,
      config,
      lib,
      pkgs,
      pkgs-unstable,
      ...
    }:
    lib.optionalAttrs (host.class == "nixos") {
      home.packages = with pkgs-unstable; [
        wl-clipboard
      ];

      home.shellAliases = {
        update = "sudo nixos-rebuild switch";
        rebuild = "nh os switch $HOME/nix-config -H $(hostname)";
        hm-rebuild = "nh home switch -c ${config.home.username}@$(hostname) $HOME/nix-config";
      };

      # Keep the OS login shell conventional for compatibility, but use Fish
      # for interactive sessions.
      # Source: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
      programs.bash = {
        enable = true;
        initExtra = import ./_fish-handoff.nix {
          inherit lib;
          fishBin = "${pkgs.fish}/bin/fish";
          parentCommand = "${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm";
          executionStringVar = "\${BASH_EXECUTION_STRING}";
          beforeExec = ''
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          '';
          fishArgs = "$LOGIN_OPTION";
        };
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
