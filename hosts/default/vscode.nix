{ inputs, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers
      james-yu.latex-workshop
      jnoortheen.nix-ide
      mhutchie.git-graph
      eamodio.gitlens
      streetsidesoftware.code-spell-checker
      # arrterian.nix-env-selector
      mkhl.direnv
      github.copilot
      github.copilot-chat
      ritwickdey.liveserver
      # vscodevim.vim
      ms-vscode.cpptools
      astro-build.astro-vscode
        unifiedjs.vscode-mdx
        firefox-devtools.vscode-firefox-debug
        ms-toolsai.jupyter-renderers
        yzhang.markdown-all-in-one
        tamasfe.even-better-toml
        charliermarsh.ruff
        samuelcolvin.jinjahtml
    ] ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      streetsidesoftware.code-spell-checker-french
        tyriar.lorem-ipsum
    ]);
    userSettings = {
      "editor.wordWrap" = "on";
      "workbench.colorTheme" = "Default Dark Modern";
      "window.zoomLevel" = 1;
      "latex-workshop.intellisense.citation.type" = "browser";
      "editor.minimap.enabled" = false;
      "[nix]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
      };
      "extensions.ignoreRecommendations" = false;
      "window.titleBarStyle" = "custom";
      "workbench.activityBar.location" = "top";
        "editor.fontFamily" = "Hack Nerd Font";
        "terminal.integrated.fontFamily" = "Hack Nerd Font";
        "nix.formatterPath" = "nixfmt";
        "editor.find.cursorMoveOnType" = false;
        "python.analysis.typeCheckingMode" = "basic";
        "update.mode" = "manual"; # Disable updates notifications
    };
    keybindings = [
      { key = "ctrl+alt+f"; command = "workbench.action.toggleMaximizeEditorGroup"; }
      { key = "ctrl+alt+="; command = "workbench.action.increaseViewSize"; }
      { key = "ctrl+alt+-"; command = "workbench.action.decreaseViewSize"; }
        { key = "alt+left"; command = "workbench.action.navigateBack"; when = "canNavigateBack"; }
        { key = "alt+right"; command = "workbench.action.navigateForward"; when = "canNavigateForward"; }
    ];
  };
}