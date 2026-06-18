{
  den.aspects.terminal.homeManager =
    {
      pkgs,
      pkgs-unstable,
      lib,
      config,
      ...
    }:
    let
      fishBin = "${pkgs.fish}/bin/fish";
      mkFishHandoff =
        {
          parentCommand,
          executionStringVar,
          beforeExec ? "",
          fishArgs ? "",
        }:
        ''
          if [[ $(${parentCommand}) != "fish" && -z ${executionStringVar} ]]
          then
            ${beforeExec}
            exec ${fishBin}${lib.optionalString (fishArgs != "") " ${fishArgs}"}
          fi
        '';
    in
    {
      home.packages = with pkgs-unstable; [
        dnsutils
        wget
        unzip
        gdu
        yt-dlp
        fd
        jq
      ];

      home.shellAliases = {
        ls = "eza";
        l = "ls";
        la = "ls -la";
        ll = "ls -l";
        lla = "ls -la";

        y = "yazi";

        hm-rebuild = "home-manager switch --flake $HOME/nix-config";
        nfu = "nix flake update --flake $HOME/nix-config";

        lg = lib.mkIf config.programs.lazygit.enable "lazygit";
        ld = lib.mkIf config.programs.lazydocker.enable "lazydocker";

        fzf = "fzf --preview 'bat --style=numbers --color=always {}'";

        # Command to work with flakes without worrying about git; source: https://mtlynch.io/notes/use-nix-flake-without-git/
        git-ignoreflake = ''
          git add --intent-to-add -f flake.nix flake.lock &&
          git update-index --assume-unchanged flake.nix flake.lock
        '';

        neofetch = lib.mkIf config.programs.fastfetch.enable "fastfetch";
      };

      # Keep the OS login shell conventional for compatibility, but use fish
      # for interactive sessions. Bash and Zsh need different guards because
      # they have different startup variables and macOS uses BSD ps.
      # Source: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
      programs.bash = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        enable = true;
        initExtra = mkFishHandoff {
          parentCommand = "${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm";
          executionStringVar = "\${BASH_EXECUTION_STRING}";
          beforeExec = ''
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          '';
          fishArgs = "$LOGIN_OPTION";
        };
      };

      programs.zsh = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        enable = true;
        initContent = mkFishHandoff {
          parentCommand = "ps -o comm= -p \"$PPID\"";
          executionStringVar = "\${ZSH_EXECUTION_STRING}";
          fishArgs = "-l";
        };
      };

      programs.fish = {
        enable = true;
        plugins = [
          # reloads fish completions whenever directories are added to $XDG_DATA_DIRS,
          # e.g. in nix shells or direnv
          {
            name = "fish-completion-sync";
            src = pkgs.fetchFromGitHub {
              owner = "iynaix";
              repo = "fish-completion-sync";
              rev = "4f058ad2986727a5f510e757bc82cbbfca4596f0";
              hash = "sha256-kHpdCQdYcpvi9EFM/uZXv93mZqlk1zCi2DRhWaDyK5g=";
            };
          }
        ];
        interactiveShellInit = ''
          set fish_greeting
          neofetch
        '';
      };

      programs.btop.enable = true;

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
      programs.fastfetch.enable = true;
      programs.spotify-player.enable = true;

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
