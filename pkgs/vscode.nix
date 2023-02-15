{
  config,
  pkgs,
  inputs,
  self,
  lib,
  ...
}: {
  programs.vscode = with pkgs; {
    enable = true;
    mutableExtensionsDir = true;

    extensions = with vscode-extensions;
      [
        bradlc.vscode-tailwindcss
        catppuccin.catppuccin-vsc
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        github.copilot
        jnoortheen.nix-ide
        kamadorueda.alejandra
        matklad.rust-analyzer
        mkhl.direnv
        ms-vscode-remote.remote-ssh
        pkief.material-product-icons
        pkief.material-icon-theme
        vscodevim.vim
      ]
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vs-code-prettier-eslint";
          publisher = "rvest";
          version = "5.0.4";
          sha256 = "sha256-aLEAuFQQTxyFSfr7dXaYpm11UyBuDwBNa0SBCMJAVRI=";
        }
        {
          name = "tailwind-class-sorter";
          publisher = "vdanchenkov";
          version = "0.0.1";
          sha256 = "sha256-hRcos9VgCaAdMMJBnJswzNrX8714ld/tOq+O6m9p3sI=";
        }
      ];

    userSettings = {
      breadcrumbs.enabled = false;
      emmet.useInlineCompletions = true;
      github.copilot.enable."*" = true;
      javascript.updateImportsOnFileMove.enabled = "always";
      scss.lint.unknownAtRules = "ignore";
      security.workspace.trust.untrustedFiles = "open";
      update.mode = "none";

      "[css]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[html]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[javascript]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[json]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[jsonc]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[nix]".editor.defaultFormatter = "kamadorueda.alejandra";
      "[rust]".editor.defaultFormatter = "rust-lang.rust-analyzer";
      "[scss]".editor.defaultFormatter = "sibiraj-s.vscode-scss-formatter";
      "[typescript]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[typescriptreact]".eslint.validate = [
        "javascript"
        "javascriptreact"
        "typescript"
        "typescriptreact"
      ];

      editor = {
        cursorBlinking = "smooth";
        cursorSmoothCaretAnimation = "on";
        cursorWidth = 2;
        defaultFormatter = "rvest.vs-code-prettier-eslint";
        find.addExtraSpaceOnTop = false;
        fontFamily = "'Maple Mono NF'";
        fontLigatures = true;
        fontSize = 16;
        formatOnSave = true;
        guides.bracketPairs = true;
        inlayHints.enabled = "off";
        inlineSuggest.enabled = true;
        largeFileOptimizations = false;
        lineNumbers = "on";
        linkedEditing = true;
        maxTokenizationLineLength = 60000;
        minimap.enabled = false;
        quickSuggestions.strings = true;
        renderWhitespace = "all";
        smoothScrolling = true;
        suggest.showStatusBar = true;
        suggestSelection = "first";

        bracketPairColorization = {
          enabled = true;
          independentColorPoolPerBracketType = true;
        };

        codeActionsOnSave.source = {
          organizeImports = true;
          fixAll.eslint = true;
        };

        unicodeHighlight.allowedCharacters = {
          "️" = true;
          "〇" = true;
          "’" = true;
        };
      };

      eslint = {
        format.enable = true;
        lintTask.enable = true;
        useESLintClass = true;
      };

      explorer = {
        confirmDragAndDrop = false;
        confirmDelete = true;
      };

      files = {
        autoSave = "afterDelay";
        eol = "\n";
        insertFinalNewline = true;

        exclude = {
          "**/.classpath" = true;
          "**/.direnv" = true;
          "**/.factorypath" = true;
          "**/.git" = true;
          "**/.project" = true;
          "**/.settings" = true;
        };
      };

      git = {
        autofetch = true;
        confirmSync = false;
        enableSmartCommit = true;
      };

      rust-analyzer = {
        procMacro.enable = true;
        signatureInfo.documentation.enable = false;
      };

      terminal.integrated = {
        cursorBlinking = true;
        cursorStyle = "line";
        cursorWidth = 2;
        fontFamily = "'Maple Mono NF'";
        fontSize = 16;
        smoothScrolling = true;

        ignoreProcessNames = [
          "starship"
          "bash"
          "zsh"
          "fish"
          "nu"
        ];
      };

      vim = {
        enableNeovim = true;
        neovimConfigPath = "~/.config/nvim/init.lua";
        neovimPath = "/home/marshall/.nix-profile/bin/nvim";
        neovimUseConfigFile = true;

        cursorStylePerMode = {
          normal = "block";
          insert = "line";
          replace = "underline";
          visual = "block-outline";
          visualblock = "block-outline";
          visualline = "block-outline";
        };
      };

      window = {
        titleBarStyle = "custom";
        zoomLevel = 1;
      };

      workbench = {
        colorTheme = "Catppuccin Mocha";
        iconTheme = "material-icon-theme";
        smoothScrolling = true;
      };
    };

    # package =
    #   (vscode.override {
    #     isInsiders = true;
    #   })
    #   .overrideAttrs
    #   (_: {
    #     src = builtins.fetchTarball {
    #       url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #       sha256 = "0za3yinia60spbmn1xsmp64lq0c6hyyhbyq42hxhdc0j54pbchfz";
    #     };
    #     version = "latest";
    #   });
  };
}
