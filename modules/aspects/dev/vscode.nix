{
  den.aspects.vscode.homeManager =
    { pkgs-unstable, ... }:
    {
      programs.vscode = {
        enable = true;
        package = pkgs-unstable.code-cursor;
        # package = pkgs-unstable.code-cursor.overrideAttrs (oldAttrs: rec {
        #   pname = "cursor";
        #   version = "2.0.43";
        #   src = pkgs-unstable.appimageTools.extract {
        #     inherit pname version;
        #     src = pkgs-unstable.fetchurl {
        #       # curl -s https://api2.cursor.sh/updates/api/download/stable/linux-x64/cursor | jq
        #       url = "https://downloads.cursor.com/production/7a31bffd467aa2d9adfda69076eb924e9062cb27/linux/x64/Cursor-2.0.54-x86_64.AppImage";
        #       hash = "sha256-ndss1uOAHk04Y6KnPWGqm+dTyGCrVOR1uJW/8nD/T/s=";
        #     };
        #   };
        #   sourceRoot = "${pname}-${version}-extracted/usr/share/cursor";
        # });
        profiles.default = {
          # extensions = with pkgs-unstable.vscode-extensions; [
          #   ms-python.python
          #   ms-python.vscode-pylance
          #   ms-toolsai.jupyter
          #   ms-azuretools.vscode-docker
          #   ms-vscode-remote.remote-ssh
          #   ms-vscode-remote.remote-containers
          #   james-yu.latex-workshop
          #   jnoortheen.nix-ide
          #   mhutchie.git-graph
          #   # eamodio.gitlens
          #   streetsidesoftware.code-spell-checker
          #   # arrterian.nix-env-selector
          #   mkhl.direnv
          #   github.copilot
          #   github.copilot-chat
          #   ritwickdey.liveserver
          #   # vscodevim.vim
          #   ms-vscode.cpptools
          #   astro-build.astro-vscode
          #   unifiedjs.vscode-mdx
          #   firefox-devtools.vscode-firefox-debug
          #   ms-toolsai.jupyter-renderers
          #   yzhang.markdown-all-in-one
          #   tamasfe.even-better-toml
          #   charliermarsh.ruff
          #   samuelcolvin.jinjahtml
          #   myriad-dreamin.tinymist
          # ] ++ (with inputs.nix-vscode-extensions.extensions.${pkgs-unstable.system}.vscode-marketplace; [
          #   streetsidesoftware.code-spell-checker-french
          #   tyriar.lorem-ipsum
          # ]);
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
            "extensions.ignoreRecommendations" = true;
            "window.titleBarStyle" = "custom";
            "editor.fontFamily" = "Hack Nerd Font";
            "terminal.integrated.fontFamily" = "Hack Nerd Font";
            "nix.formatterPath" = "nixfmt";
            "editor.find.cursorMoveOnType" = false;
            "python.analysis.typeCheckingMode" = "basic";
            "update.mode" = "manual"; # Disable updates notifications.
            "jupyter.runStartupCommands" = [ "direnv allow ." ]; # Set up dev shell for Jupyter.
            "dataWrangler.outputRenderer.columnInsights.displayByDefault" = true;
            "dataWrangler.enabledFileTypes".jsonl = true;
            "dataWrangler.panels.displayOnTabFocus" = true;
            "editor.renderWhitespace" = "boundary";
            "notebook.diff.ignoreMetadata" = true;
            "notebook.diff.ignoreOutputs" = true;
            "window.autoDetectColorScheme" = true;

            # Cursor settings.
            "cursor.cpp.enablePartialAccepts" = true;
            "cursor.cpp.disabledLanguages" = [ ];
            "cursor.composer.shouldChimeAfterChatFinishes" = true;
            "cursor.diffs.useCharacterLevelDiffs" = true;
            "cursor.composer.usageSummaryDisplay" = "always";
          };
          keybindings = [
            { key = "ctrl+alt+f"; command = "workbench.action.toggleMaximizeEditorGroup"; }
            { key = "ctrl+alt+="; command = "workbench.action.increaseViewSize"; }
            { key = "ctrl+alt+-"; command = "workbench.action.decreaseViewSize"; }
            { key = "alt+left"; command = "workbench.action.navigateBack"; when = "canNavigateBack"; }
            { key = "alt+right"; command = "workbench.action.navigateForward"; when = "canNavigateForward"; }
            { key = "ctrl+tab"; command = "workbench.action.nextEditor"; }
            { key = "ctrl+shift+tab"; command = "workbench.action.previousEditor"; }
          ];
        };
      };
    };
}
