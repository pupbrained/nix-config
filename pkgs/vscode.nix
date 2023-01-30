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
        bbenoist.nix
        bradlc.vscode-tailwindcss
        catppuccin.catppuccin-vsc
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        github.copilot
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
        procMacro.enable = false;
        signatureInfo.documentation.enable = false;

        rustfmt.extraArgs = [
          "--config [tab_spaces=2]"
        ];
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

    package =
      (vscode.override {
        isInsiders = true;
      })
      .overrideAttrs
      (_: {
        src = builtins.fetchTarball {
          url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
          sha256 = "0za3yinia60spbmn1xsmp64lq0c6hyyhbyq42hxhdc0j54pbchfz";
        };
        version = "latest";
      });
  };

  home.file = let
    inherit (lib) mkMerge concatMap;
    cfg = config.programs.vscode;
    subDir = "share/vscode/extensions";
    extensionPath = ".vscode-insiders/extensions";

    toPaths = ext:
      map (k: {"${extensionPath}/${k}".source = "${ext}/${subDir}/${k}";})
      (
        if ext ? vscodeExtUniqueId
        then [ext.vscodeExtUniqueId]
        else builtins.attrNames (builtins.readDir (ext + "/${subDir}"))
      );
  in
    mkMerge ((concatMap toPaths cfg.extensions)
      ++ [
        {
          ".vscode-insiders/extensions/extensions.json".text = let
            toExtensionJsonEntry = drv: rec {
              identifier = {
                id = "${drv.vscodeExtPublisher}.${drv.vscodeExtName} ";
                uuid = "";
              };

              inherit (drv) version;

              location = {
                "$mid" = 1;
                fsPath = drv.outPath + "/share/vscode/extensions/${drv.vscodeExtUniqueId}";
                path = location.fsPath;
                scheme = "file";
              };

              metadata = {
                id = identifier.uuid;
                publisherId = "";
                publisherDisplayName = drv.vscodeExtPublisher;
                targetPlatform = "undefined";
                isApplicationScoped = false;
                updated = false;
                isPreReleaseVersion = false;
                installedTimestamp = 0;
                preRelease = false;
              };
            };
            x = builtins.toJSON (map toExtensionJsonEntry config.programs.vscode.extensions);
          in
            x;
        }
      ]);
}
