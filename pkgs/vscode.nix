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
        formulahendry.auto-rename-tag
        jnoortheen.nix-ide
        kamadorueda.alejandra
        matklad.rust-analyzer-nightly
        mkhl.direnv
        ms-vscode-remote.remote-ssh
        mvllow.rose-pine
        nvarner.typst-lsp
        ocamllabs.ocaml-platform
        pkief.material-product-icons
        pkief.material-icon-theme
        rubymaniac.vscode-paste-and-indent
        sumneko.lua
        tamasfe.even-better-toml
        vincaslt.highlight-matching-tag
        vscodevim.vim
      ]
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "autoimport";
          publisher = "steoates";
          version = "1.5.4";
          sha256 = "sha256-7iIwJJsoNbtTopc+BQ+195aSCLqdNAaGtMoxShyhBWY=";
        }
        {
          name = "catppuccin-vsc-icons";
          publisher = "Catppuccin";
          version = "0.10.0";
          sha256 = "sha256-ikDF2BL4/+JVo74iOrokJ188kYHxLKzqeAM6J75FjOE=";
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
          version = "0.14.884";
          sha256 = "sha256-44t4qdRjw/sdAmO6uW9CaLzs0hJcK+uQnpalCNB8AdM=";
        }
        {
          name = "copilot-nightly";
          publisher = "github";
          version = "1.86.92";
          sha256 = "sha256-h6tvHRU38AF9KxHPdyAnyIh44kJOhRJ9ku6GPnamXGU=";
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
          name = "stylua";
          publisher = "JohnnyMorganz";
          version = "1.5.0";
          sha256 = "sha256-+v/xOB/r+AN1n+Y8LtprIIYckXBF8u57z3JxOS9982g=";
        }
        {
          name = "tauri-vscode";
          publisher = "tauri-apps";
          version = "0.2.6";
          sha256 = "sha256-O9NxFemUgt9XmhL6BnNArkqbCNtHguSbvVOYwlT0zg4=";
        }
        {
          name = "unocss";
          publisher = "antfu";
          version = "0.51.13";
          sha256 = "sha256-0v7irYNHIUcFDkjWLm18jgwFXBsR2ATQ3wWxb1Rx9uE=";
        }
        {
          name = "vs-code-prettier-eslint";
          publisher = "rvest";
          version = "5.1.0";
          sha256 = "sha256-nOwmLjAmjElX+IAoxVBHlXEowM/GmlabwGd8KqGxB14=";
        }
        {
          name = "vscode-better-align";
          publisher = "chouzz";
          version = "1.4.2";
          sha256 = "sha256-w30DAQpCxc3qP6/S/9qf/nQasLU3qy5flCBlTGRoYzk=";
        }
        {
          name = "vscode-surround";
          publisher = "yatki";
          version = "1.5.0";
          sha256 = "sha256-4IF6uR6DgJewmaUOUfziynSLvXXXUDv+RXjX1TH5Zso=";
        }
        {
          name = "vsliveshare";
          publisher = "ms-vsliveshare";
          version = "1.0.5864";
          sha256 = "sha256-UdI9iRvI/BaZj8ihFBCTFJGLZXxS3CtmoDw8JBPbzLY=";
        }
        {
          name = "wrapSelection";
          publisher = "konstantin";
          version = "0.10.0";
          sha256 = "sha256-bpQYJImY0bx+d/1jfL71a+WjSyBq6VGhw330OwB+Mho=";
        }
      ];

    userSettings = {
      auto-rename-tag.activationOnLanguage = [
        "xml"
        "javascript"
        "typescript"
        "javascriptreact"
        "typescriptreact"
        "php"
      ];
      breadcrumbs.enabled = false;
      emmet.useInlineCompletions = true;
      github.copilot.enable."*" = true;
      javascript.updateImportsOnFileMove.enabled = "always";
      Lua.diagnostics.globals = ["vim"];
      typescript.updateImportsOnFileMove.enabled = "always";
      scss.lint.unknownAtRules = "ignore";
      security.workspace.trust.untrustedFiles = "open";
      trunk.trunkGrayOutNonBlockingIssues = false;
      update.mode = "none";

      "[css]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[html]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[javascript]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[json]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[jsonc]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[lua]".editor.defaultFormatter = "JohnnyMorganz.stylua";
      "[nix]".editor.defaultFormatter = "kamadorueda.alejandra";
      "[postcss]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[rust]".editor.defaultFormatter = "rust-lang.rust-analyzer";
      "[scss]".editor.defaultFormatter = "sibiraj-s.vscode-scss-formatter";
      "[typescript]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[typescriptreact]".eslint.validate = ["javascript" "javascriptreact" "typescript" "typescriptreact"];

      editor = {
        accessibilitySupport = "off";
        cursorBlinking = "smooth";
        cursorSmoothCaretAnimation = "on";
        cursorWidth = 2;
        defaultFormatter = "rvest.vs-code-prettier-eslint";
        find.addExtraSpaceOnTop = false;
        fontFamily = "'Iosevka Comfy', 'Iosevka Nerd Font'";
        fontLigatures = true;
        fontSize = 18;
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
          "**/.trunk/*out/" = true;
          "**/.trunk/*actions/" = true;
          "**/.trunk/*logs/" = true;
          "**/.trunk/*plugins/" = true;
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
        check.command = "clippy";
        checkOnSave.overrideCommand = [
          "cargo"
          "clippy"
          "--fix"
          "--workspace"
          "--message-format=json"
          "--all-targets"
          "--allow-dirty"
        ];
      };

      terminal.integrated = {
        cursorBlinking = true;
        cursorStyle = "line";
        cursorWidth = 2;
        fontFamily = "'Iosevka Comfy', 'Iosevka Nerd Font'";
        fontSize = 18;
        smoothScrolling = true;
        env.osx.FIG_NEW_SESSION = "1";

        ignoreProcessNames = ["starship" "bash" "zsh" "fish" "nu"];
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
