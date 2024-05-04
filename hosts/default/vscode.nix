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

    ] ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      sourcegraph.cody-ai
      streetsidesoftware.code-spell-checker-french
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
    };
    keybindings = [
      { key = "ctrl+alt+f"; command = "workbench.action.toggleMaximizeEditorGroup"; }
      { key = "ctrl+alt+="; command = "workbench.action.increaseViewSize"; }
      { key = "ctrl+alt+-"; command = "workbench.action.decreaseViewSize"; }
    ];
  };
}