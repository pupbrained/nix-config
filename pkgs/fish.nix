{pkgs, ...}: {
  programs.fish = {
    enable = true;

    plugins = with pkgs; [
      {
        name = "replay.fish";
        src = fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "replay.fish";
          rev = "bd8e5b89ec78313538e747f0292fcaf631e87bd2";
          hash = "sha256-bM6+oAd/HXaVgpJMut8bwqO54Le33hwO9qet9paK1kY=";
        };
      }
      {
        name = "license";
        src = fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-license";
          rev = "0155b16f102957ec0c734a90979245dc1073f979";
          hash = "sha256-Bi9Q5rekZoyXYbRV+U4SmwCdqCl0pFupzm5si7SxFns=";
        };
      }
      {
        name = "wttr";
        src = fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-wttr";
          rev = "7500e382e6b29a463edc57598217ce0cfaf8c90c";
          hash = "sha256-k3FrRPxKCiObO6HgtDx8ORbcLmfSYQsQeq5SAoNfZbE=";
        };
      }
      {
        name = "gityaw";
        src = fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-gityaw";
          rev = "59196560e0f4520db63fb8cab645510377bb8b13";
          hash = "sha256-STXNxSsjSopB+lbB4hEYdhJifRfsImRwbZ1SxwEhkuM=";
        };
      }
      {
        name = "brew";
        src = fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-brew";
          rev = "0021f7a2491df3c88e11786df366dc2030f939bb";
          hash = "sha256-drMyXCrgcqqbev1WmoZ3HzCe0bKzx14AJs2FxbfS26I=";
        };
      }
      {
        name = "bang-bang";
        src = fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-bang-bang";
          rev = "816c66df34e1cb94a476fa6418d46206ef84e8d3";
          hash = "sha256-35xXBWCciXl4jJrFUUN5NhnHdzk6+gAxetPxXCv4pDc=";
        };
      }
      {
        name = "grc";
        src = fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-grc";
          rev = "61de7a8a0d7bda3234f8703d6e07c671992eb079";
          hash = "sha256-NQa12L0zlEz2EJjMDhWUhw5cz/zcFokjuCK5ZofTn+Q=";
        };
      }
    ];

    shellAliases = {
      ls = "eza --icons";
      ll = "eza --icons -l";
      la = "eza --icons -a";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gca = "git commit --amend";
      gco = "git checkout";
      gcb = "git checkout -b";
      ga = "git add";
      gap = "git add --patch";
      gaa = "git add --all";
      gp = "git push";
      gpl = "git pull";
      gcap = "git add && git commit && git push";
      vi = "nvim";
      vim = "nvim";
      cat = "bat";
      df = "duf";
      rm = "rip";
      cp = "xcp";
    };

    loginShellInit = ''
      ssh-add --apple-load-keychain 2>/dev/null &
    '';

    interactiveShellInit = ''
      set fish_greeting
      set -gx PNPM_HOME /Users/marshall/Library/pnpm
      fish_add_path /Users/marshall/.spicetify
      fish_add_path $PNPM_HOME
      fish_add_path /run/current-system/sw/bin
      fish_add_path /Users/marshall/miniforge3/bin
      fish_add_path /Users/marshall/.bun/bin
      set -gx LIBRARY_PATH /opt/homebrew/lib:/opt/homebrew/opt/libiconv/lib
      set -gx NIXPKGS_ALLOW_UNFREE 1

      set -gx ONYX_PATH /Users/marshall/.onyx
      fish_add_path $ONYX_PATH/bin

      if test "$TERM_PROGRAM" != "vscode"
        macchina
      end
      printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
    '';
  };
}
