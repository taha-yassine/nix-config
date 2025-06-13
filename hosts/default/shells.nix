{
  pkgs,
  unstable,
  lib,
  config,
  ...
}: {
  home.shellAliases = {
    ls = "eza";
    l = "ls";
    la = "ls -la";
    ll = "ls -l";
    lla = "ls -la";

    y = "yazi";

    update = "sudo nixos-rebuild switch";

    lg = "lazygit";
    
    fzf = "fzf --preview 'bat --style=numbers --color=always {}'";
    
    # Command to work with flakes without worrying about git; source: https://mtlynch.io/notes/use-nix-flake-without-git/ 
    git-ignoreflake = ''
      git add --intent-to-add -f flake.nix flake.lock &&
      git update-index --assume-unchanged flake.nix flake.lock
    '';

    neofetch = lib.mkIf config.programs.fastfetch.enable "fastfetch";
  };

  programs.bash = {
    enable = true;
    # Keep bash as default shell and only use fish in interactive shells
    # Source: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.zsh = {
    enable = false;

    autosuggestion.enable = true;

    syntaxHighlighting.enable = true;
    
    zplug = {
      enable = true;
      plugins = [
        { name = "dracula/zsh"; tags = ["as:theme"]; }
        # { name = "jeffreytse/zsh-vi-mode"; }
      ];
    };

    initExtra = ''
      # aichat integration
      _aichat_zsh() {
          if [[ -n "$BUFFER" ]]; then
              local _old=$BUFFER
              BUFFER+="⌛"
              zle -I && zle redisplay
              BUFFER=$(aichat -m openrouter:mistralai/mistral-large -e "$_old")
              zle end-of-line
          fi
      }
      zle -N _aichat_zsh
      bindkey -r '^K'
      bindkey '^K' _aichat_zsh

      # function zvm_after_lazy_keybindings() {
      #   zvm_define_widget _aichat_zsh
      #   zvm_bindkey vicmd '^K' _aichat_zsh
      # }

      # Define autocomplete for devshell init
      # Credits: https://github.com/SoraTenshi/nixos-config/blob/a2db14ba3480f1ea265e152d0829c8c70783861e/home/shells/zsh/default.nix
      devshell() {
        nix flake init --template github:the-nix-way/dev-templates#$1 && ${pkgs.direnv}/bin/direnv allow
      }

      _devshell() {
        compadd c-cpp clojure csharp cue dhall elixir elm gleam go \
           hashi haskell java kotlin latex nickel nim nix node ocaml \
           opa php protobuf purescript python ruby rust-toolchain rust scala shell zig
      }
      compdef _devshell devshell
      # End definition of devshell
    '';

    enableCompletion = false; # Temp fix for slow zsh startup; until https://github.com/nix-community/home-manager/pull/6063 is merged

    # Enable profiler; for debugging purposes
    # zprof.enable = true;
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
  };
}
