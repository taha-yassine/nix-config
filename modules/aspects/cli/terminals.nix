{
  den.aspects.terminals.homeManager =
    { pkgs-unstable, ... }:
    {
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
