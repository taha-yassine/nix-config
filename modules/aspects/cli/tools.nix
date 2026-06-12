{
  den.aspects.cli-tools.homeManager =
    {
      pkgs,
      pkgs-unstable,
      lib,
      ...
    }:
    {
      home.packages = with pkgs-unstable; [
        dnsutils
        wget
        unzip
        gdu
        yt-dlp
        wl-clipboard
        fd
        jq
      ];

      programs.btop = {
        enable = true;
        package = pkgs-unstable.btop.override {
          cudaSupport = true;
          rocmSupport = true;
        };
      };

      programs.starship = {
        enable = true;
        settings = {
          add_newline = false;
          format = "$all\n$character";
          line_break.disabled = true;
          command_timeout = 2000;
          character = {
            success_symbol = "[>](bold green)";
            error_symbol = "[>](bold red)";
          };
        };
      };

      programs.zellij.settings.theme = "molokai-dark";
      programs.lazydocker.enable = true;
      programs.fzf.enable = true;

      programs.television = {
        enable = true;
        channels = {
          text = {
            metadata = {
              name = "text";
              description = "A channel to find and select text from files";
              requirements = [
                "rg"
                "bat"
              ];
            };
            source = {
              command = "rg . --no-heading --line-number --colors 'match:fg:white' --colors 'path:fg:blue' --color=always";
              ansi = true;
              output = "{strip_ansi|split:\\::..2}";
            };
            preview = {
              command = "bat -n --color=always '{strip_ansi|split:\\::0}'";
              env.BAT_THEME = "ansi";
              offset = "{strip_ansi|split:\\::1}";
            };
            ui.preview_panel.header = "{strip_ansi|split:\\::..2}";
            actions.edit = {
              description = "Edit selected file";
              command = "nvim +{split:\\::1} {split:\\::0}";
              mode = "execute";
            };
            keybindings.ctrl-e = "actions:edit";
          };
        };
      };

      programs.nix-search-tv.enable = true;
      programs.bat.enable = true;

      programs.yazi = {
        enable = true;
        settings.show_hidden = true;
      };

      programs.atuin = {
        enable = true;
        settings = {
          filter_mode = "directory";
          enter_accept = true;
        };
      };

      programs.eza = {
        enable = true;
        git = true;
        icons = "auto";
        extraOptions = [
          "--group-directories-first"
          "--header"
          "--octal-permissions"
          "--hyperlink"
          "--all"
        ];
      };

      programs.ripgrep.enable = true;
      programs.nh.enable = true;
      programs.fastfetch.enable = true;
      programs.spotify-player.enable = true;
      programs.nix-index.enable = true;

      xdg.configFile."aichat/config.yaml".text = lib.generators.toYAML { } {
        prelude = "session:default";
        model = "openrouter:anthropic/claude-3-5-haiku";
        clients = [
          {
            type = "openai-compatible";
            name = "openrouter";
            api_base = "https://openrouter.ai/api/v1";
          }
        ];
      };
    };
}
