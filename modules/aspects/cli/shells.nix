{
  den.aspects.shells.homeManager =
    {
      pkgs,
      lib,
      config,
      host,
      user,
      ...
    }:
    {
      home.shellAliases = {
        ls = "eza";
        l = "ls";
        la = "ls -la";
        ll = "ls -l";
        lla = "ls -la";

        y = "yazi";

        update = "sudo nixos-rebuild switch";
        rebuild = "nh os switch $HOME/nix-config -H ${host.name}";
        hm-rebuild = "nh home switch -c ${user.userName}@${host.name} $HOME/nix-config";
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

      # Keep bash as default shell and only use fish in interactive shells.
      # Source: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
      programs.bash = {
        enable = true;
        initExtra = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
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
    };
}
