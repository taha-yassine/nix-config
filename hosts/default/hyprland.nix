{
  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = "swww init & nm-applet --indicator & waybar & dunst";

      # Programs
      "$terminal" = "kitty";
      # "$fileManager" = "dolphin";
      "$menu" = "rofi";

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        touchpad = {
          natural_scroll = "true";
        };
        follow_mouse = 2; # Click to focus

      };

      # Gestures
      gestures = {
        workspace_swipe = "true";
      };

      monitor = "monitor=,preferred,auto,auto";

      bind = [
        "SUPER, S, exec, rofi -show drun -show-icons"
        "SUPER, Q, exec, $terminal"
        "SUPER, V, togglefloating,"
        "SUPER, C, killactive,"
        "SUPER, M, exit,"
      # Move active window to a workspace with mainMod + SHIFT + [0-9]
        # bind = $mainMod SHIFT, 1, movetoworkspace, 1
        # bind = $mainMod SHIFT, 2, movetoworkspace, 2
        # bind = $mainMod SHIFT, 3, movetoworkspace, 3
        # bind = $mainMod SHIFT, 4, movetoworkspace, 4
        # bind = $mainMod SHIFT, 5, movetoworkspace, 5
        # bind = $mainMod SHIFT, 6, movetoworkspace, 6
        # bind = $mainMod SHIFT, 7, movetoworkspace, 7
        # bind = $mainMod SHIFT, 8, movetoworkspace, 8
        # bind = $mainMod SHIFT, 9, movetoworkspace, 9
        # bind = $mainMod SHIFT, 0, movetoworkspace, 10
        # Move focus with SUPER + arrow keys
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
      ];

      bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER_CTRL, mouse:272, resizewindow"
      ];
    };
  };

  home.packages = (with pkgs; [ # Stable
  ]) ++ (with unstable; [ # Unstable
    libnotify
    swww
    networkmanagerapplet
  ]);

  # Waybar
  programs.waybar.enable = true;

  # Rofi
  programs.rofi.enable = true;

  # Dunst
  services.dunst.enable = true;

}