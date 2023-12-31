{pkgs, ...}: {
  programs = {
    fish = {
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
          src = pkgs.fishPlugins.grc.src;
        }
      ];

      shellAliases = with pkgs; {
        ls = "eza --icons";
        ll = "eza --icons -l";
        la = "eza --icons -a";
        lt = "eza --icons -T";
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
        df = "${duf}/bin/duf";
        rm = "${rm-improved}/bin/rip";
        cp = "${xcp}/bin/xcp";
      };

      interactiveShellInit = ''
        set fish_greeting
        macchina
      '';
    };

    starship = {
      enable = true;

      settings = {
        jobs.disabled = true;
        palette = "catppuccin_mocha";
        nix_shell.symbol = "❄️  ";

        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
    };

    zoxide = {
      enable = true;
      options = ["--cmd" "cd"];
    };
  };
}
