{pkgs, ...}: {
  programs.vscode = with pkgs; {
    enable = true;
    mutableExtensionsDir = true;

    package = pkgs.callPackage ./insiders.nix {};

    extensions = with vscode-extensions;
      [
        bradlc.vscode-tailwindcss
        catppuccin.catppuccin-vsc
        christian-kohler.path-intellisense
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        formulahendry.auto-close-tag
        foxundermoon.shell-format
        github.copilot-chat
        github.vscode-pull-request-github
        ibm.output-colorizer
        jnoortheen.nix-ide
        kamadorueda.alejandra
        kamikillerto.vscode-colorize
        mkhl.direnv
        ms-vscode-remote.remote-ssh
        oderwat.indent-rainbow
        rubymaniac.vscode-paste-and-indent
        rust-lang.rust-analyzer
        shd101wyy.markdown-preview-enhanced
        sumneko.lua
        tamasfe.even-better-toml
        usernamehw.errorlens
        vincaslt.highlight-matching-tag
        vscodevim.vim
        wix.vscode-import-cost
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
          version = "0.12.0";
          sha256 = "sha256-i47tY6DSVtV8Yf6AgZ6njqfhaUFGEpgbRcBF70l2Xe0=";
        }
        {
          name = "civet";
          publisher = "danielx";
          version = "0.3.6";
          sha256 = "sha256-VYkI+vHwvIttpgy7hV5m63BmMwP0ZXRGRdiuPl9kDAc=";
        }
        {
          name = "console-ninja";
          publisher = "wallabyjs";
          version = "0.0.182";
          sha256 = "sha256-xclu531vjCiKOV/k5ZoOGiElzrvDuyk6LsrCKHJxG6Q=";
        }
        {
          name = "copilot";
          publisher = "github";
          version = "1.95.237";
          sha256 = "sha256-9H1jEGaHURz+bThRBF4+yDgT5BYRun+dDMq5CDcxOhk=";
        }
        {
          name = "copilot-chat";
          publisher = "github";
          version = "0.3.2023061502";
          sha256 = "sha256-sUoKwlPDMz+iQbmIsD2JhyDwmUQzOyCHXaXCUaizQ7k=";
        }
        {
          name = "copilot-labs";
          publisher = "github";
          version = "0.14.884";
          sha256 = "sha256-44t4qdRjw/sdAmO6uW9CaLzs0hJcK+uQnpalCNB8AdM=";
        }
        {
          name = "hungry-delete";
          publisher = "jasonlhy";
          version = "1.7.0";
          sha256 = "sha256-TDs6i0/o0j9XFLQvWze4iloa6yRXce/xIqd2CnA5nug=";
        }
        {
          name = "lintlens";
          publisher = "ghmcadams";
          version = "7.2.0";
          sha256 = "sha256-kXw1neLuWmnK/FNF0WfY2KAz0zakw5qtrSzc1SbqMj0=";
        }
        {
          name = "postcss";
          publisher = "csstools";
          version = "1.0.9";
          sha256 = "sha256-5pGDKme46uT1/35WkTGL3n8ecc7wUBkHVId9VpT7c2U=";
        }
        {
          name = "pretty-ts-errors";
          publisher = "yoavbls";
          version = "0.4.1";
          sha256 = "sha256-vY/dVO9k3LcXLYH9eX9blKMB+mDGCWkmU9ZU62YvAcM=";
        }
        {
          name = "remote-explorer";
          publisher = "ms-vscode";
          version = "0.4.0";
          sha256 = "sha256-5OqwLiBoxf0brEXiMFkgJwSgB2LPdGTsaUm6/yG6Wj4=";
        }
        {
          name = "rome";
          publisher = "rome";
          version = "0.24.3";
          sha256 = "sha256-24Xpk4n0jRzpe8lK9YfWgTZ0Yg9iN9piyTw9Fk/nxhs=";
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
          name = "teacode-vsc-helper";
          publisher = "apptorium";
          version = "1.2.2";
          sha256 = "sha256-aXZfR0Pva7/9QuY2AqSpC2SAGxQUZeFFPHexquLvdgo=";
        }
        {
          name = "turbo-console-log";
          publisher = "chakrounanas";
          version = "2.9.3";
          sha256 = "sha256-9tNdGLn54QCZgBg7H7zxv/24kJGcw2BwYJxLSnN3WgI=";
        }
        {
          name = "unocss";
          publisher = "antfu";
          version = "0.52.7";
          sha256 = "sha256-KVh+nQwpJ004apCE3tEKzec+fzRr8Ev4JvCuZcSOTFI=";
        }
        {
          name = "intellicode-api-usage-examples";
          publisher = "visualstudioexptteam";
          version = "0.2.7";
          sha256 = "sha256-SJN5w9DCtGaCXCXXtUMhdwuajd9Az01oqHdBQ9KeQyc=";
        }
        {
          name = "vscodeintellicode-insiders";
          publisher = "visualstudioexptteam";
          version = "1.1.10";
          sha256 = "sha256-BwxXdObHrqeHK+B5+TgyUoByyrSNl1niNGTMV2rbx80=";
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
          name = "vscode-dotnet-runtime";
          publisher = "ms-dotnettools";
          version = "1.6.0";
          sha256 = "sha256-A3m5IvPKgmF2Dix1/bHFGcrJYriYsFgRagkZNcWf/RA=";
        }
        {
          name = "vscode-surround";
          publisher = "yatki";
          version = "1.5.0";
          sha256 = "sha256-4IF6uR6DgJewmaUOUfziynSLvXXXUDv+RXjX1TH5Zso=";
        }
        {
          name = "vscode-typescript-next";
          publisher = "ms-vscode";
          version = "5.2.20230531";
          sha256 = "sha256-yPQ6qkRUeOFPW67y1U7Aj/wH31I9qvMk6rAR7K6l8Fc=";
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

    keybindings = [
      {
        key = "backspace";
        command = "-extension.vim_backspace";
        when = "editorTextFocus && vim.active && !inDebugRepl";
      }
      {
        key = "backspace";
        command = "extension.vim_backspace";
        when = "editorTextFocus && vim.active && !inDebugRepl && vim.mode == 'SearchInProgressMode'";
      }
    ];

    userSettings = {
      breadcrumbs.enabled = false;
      emmet.useInlineCompletions = true;
      errorLens.replaceLinebreaksSymbol = " - ";
      github.copilot.enable."*" = true;
      javascript.updateImportsOnFileMove.enabled = "always";
      Lua.diagnostics.globals = ["vim"];
      typescript.updateImportsOnFileMove.enabled = "always";
      scss.lint.unknownAtRules = "ignore";
      security.workspace.trust.untrustedFiles = "open";
      trunk.trunkGrayOutNonBlockingIssues = false;
      update.mode = "none";

      "[javascript]" = {
        editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
        suggest.paths = false;
      };

      "[typescript]" = {
        editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
        suggest.paths = false;
      };

      "[css]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[html]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[json]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[jsonc]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[lua]".editor.defaultFormatter = "JohnnyMorganz.stylua";
      "[nix]".editor.defaultFormatter = "kamadorueda.alejandra";
      "[postcss]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[rust]".editor.defaultFormatter = "rust-lang.rust-analyzer";
      "[scss]".editor.defaultFormatter = "sibiraj-s.vscode-scss-formatter";
      "[shellscript]".editor.defaultFormatter = "foxundermoon.shell-format";
      "[typescriptreact]".eslint.validate = ["javascript" "javascriptreact" "typescript" "typescriptreact"];

      dotnetAcquisitionExtension.existingDotnetPath = [
        {
          extensionId = "vscodeintellicode-insiders";
          path = "/usr/local/share/dotnet/dotnet";
        }
      ];

      editor = {
        accessibilitySupport = "off";
        cursorBlinking = "smooth";
        cursorSmoothCaretAnimation = "on";
        cursorWidth = 2;
        defaultFormatter = "rvest.vs-code-prettier-eslint";
        find.addExtraSpaceOnTop = false;
        fontFamily = "'Maple Mono', 'Iosevka Nerd Font'";
        fontLigatures = "'cv02', 'cv03', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05'";
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
        terminal.integrated.env.osx.FIG_NEW_SESSION = "1";

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

      indentRainbow = {
        indicatorStyle = "light";
        lightIndicatorStyleLineWidth = 1;
        colors = [
          "rgba(255,255,64,0.3)"
          "rgba(127,255,127,0.3)"
          "rgba(255,127,255,0.3)"
          "rgba(79,236,236,0.3)"
        ];
      };

      rust-analyzer = {
        procMacro.enable = true;
        checkOnSave = true;
        check = {
          command = "clippy";
          overrideCommand = [
            "cargo"
            "clippy"
            "--fix"
            "--workspace"
            "--message-format=json"
            "--all-targets"
            "--allow-dirty"
          ];
        };
      };

      terminal.integrated = {
        cursorBlinking = true;
        cursorStyle = "line";
        cursorWidth = 2;
        fontFamily = "'Maple Mono', 'Iosevka Nerd Font'";
        fontSize = 18;
        smoothScrolling = true;

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
        iconTheme = "catppuccin-mocha";
        smoothScrolling = true;
      };
    };
  };
}
