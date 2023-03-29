{pkgs, ...}: {
  programs.vscode = with pkgs; {
    enable = true;
    mutableExtensionsDir = false;

    extensions = with vscode-extensions;
      [
        bradlc.vscode-tailwindcss
        catppuccin.catppuccin-vsc
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        jnoortheen.nix-ide
        kamadorueda.alejandra
        matklad.rust-analyzer-nightly
        mkhl.direnv
        ms-vscode-remote.remote-ssh
        mvllow.rose-pine
        pkief.material-product-icons
        pkief.material-icon-theme
        sumneko.lua
        tamasfe.even-better-toml
        vscodevim.vim
      ]
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "catppuccin-vsc-icons";
          publisher = "Catppuccin";
          version = "0.1.0";
          sha256 = "sha256-IVH+Z7yByJx5x8oH6sU21cf/t1FCMW8fWHd46m1jp/U=";
        }
        {
          name = "civet";
          publisher = "danielx";
          version = "0.3.6";
          sha256 = "sha256-VYkI+vHwvIttpgy7hV5m63BmMwP0ZXRGRdiuPl9kDAc=";
        }
        {
          name = "copilot-labs";
          publisher = "github";
          version = "0.12.791";
          sha256 = "sha256-3StswisTiG1e+LZeAuquIXlqaFj0Lzk4WNy+6Af4giw=";
        }
        {
          name = "copilot-nightly";
          publisher = "github";
          version = "1.78.10395";
          sha256 = "sha256-nqCg/1nX+dD1UxEaBYZnrCdfYgpCXM+fe9YpZtHU1Gc=";
        }
        {
          name = "gleam";
          publisher = "Gleam";
          version = "2.2.0";
          sha256 = "sha256-eaGprPLJWJOIlK0UB+CcdXVon+jmzpz0X0gB6uBbvt4=";
        }
        {
          name = "postcss";
          publisher = "csstools";
          version = "1.0.9";
          sha256 = "sha256-5pGDKme46uT1/35WkTGL3n8ecc7wUBkHVId9VpT7c2U=";
        }
        {
          name = "vs-code-prettier-eslint";
          publisher = "rvest";
          version = "5.1.0";
          sha256 = "sha256-nOwmLjAmjElX+IAoxVBHlXEowM/GmlabwGd8KqGxB14=";
        }
      ];

    userSettings = {
      breadcrumbs.enabled = false;
      emmet.useInlineCompletions = true;
      github.copilot.enable."*" = true;
      javascript.updateImportsOnFileMove.enabled = "always";
      Lua.diagnostics.globals = ["vim"];
      typescript.updateImportsOnFileMove.enabled = "always";
      scss.lint.unknownAtRules = "ignore";
      security.workspace.trust.untrustedFiles = "open";
      update.mode = "none";
      window.titleBarStyle = "custom";

      "[css]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[html]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[javascript]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[json]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[jsonc]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[lua]".editor.defaultFormatter = "sumneko.lua";
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
        accessibilitySupport = "off";
        cursorBlinking = "smooth";
        cursorSmoothCaretAnimation = "on";
        cursorWidth = 2;
        defaultFormatter = "rvest.vs-code-prettier-eslint";
        find.addExtraSpaceOnTop = false;
        fontFamily = "'Iosevka Comfy Wide'";
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
        fontFamily = "'Iosevka Comfy Wide'";
        fontSize = 16;
        smoothScrolling = true;
        env.osx.FIG_NEW_SESSION = "1";

        ignoreProcessNames = [
          "starship"
          "bash"
          "zsh"
          "fish"
          "nu"
        ];
      };

      vim.cursorStylePerMode = {
        normal = "block";
        insert = "line";
        replace = "underline";
        visual = "block-outline";
        visualblock = "block-outline";
        visualline = "block-outline";
      };

      workbench = {
        colorTheme = "Catppuccin Mocha";
        iconTheme = "material-icon-theme";
        smoothScrolling = true;
      };
    };
  };
}
