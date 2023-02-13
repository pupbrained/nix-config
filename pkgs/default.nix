inputs:
inputs.nixpkgs.lib.composeManyExtensions [
  (final: prev: let
    sources = prev.callPackage ./_sources/generated.nix {};

    catppuccin = "${prev.fetchFromGitHub {
      owner = "catppuccin";
      repo = "discord";
      rev = "d65e21cf2302355e1d8a50fe8f7714f6ebb1261d";
      sha256 = "sha256-EN4YKCzkYe9xOtv9tPLPVHXJOj1XODrnLy+SSZWObSY=";
    }}/themes/mocha.theme.css";

    hsl = "${prev.fetchFromGitHub {
      owner = "DiscordStyles";
      repo = "HorizontalServerList";
      rev = "b9fc8862f4bd1f24e575a687dbcf096ab338fe7f";
      sha256 = "sha256-OIs3aI30cNyUYqSogGzzE4qsbIvtciON5aI+huag4Pg=";
    }}/src/dist.css";

    addCopilot = editor:
      with inputs.nixpkgs-jetbrains.legacyPackages.${prev.system}.jetbrains.plugins; let
        info = getUrl {
          id = "17718";
          hash = "sha256-lOAVJx+xxz4gBJ4Cchq+02ArdmwMWOuGh+afU6LavNQ=";
        };
        libPath = lib.makeLibraryPath [prev.glibc prev.gcc-unwrapped];
        copilot-plugin = urlToDrv {
          name = "GitHub Copilot";
          inherit (info) url;
          hash = "sha256-117CHiwMOlEoiZBRk7hT3INncargoeYCuewpCeQ4nz8=";
          extra = {
            inputs = [prev.patchelf prev.glibc prev.gcc-unwrapped];
            commands = ''
              agent="copilot-agent/bin/copilot-agent-linux"
              orig_size=$(stat --printf=%s $agent)
              patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $agent
              patchelf --set-rpath ${libPath} $agent
              chmod +x $agent
              new_size=$(stat --printf=%s $agent)
              # https://github.com/NixOS/nixpkgs/pull/48193/files#diff-329ce6280c48eac47275b02077a2fc62R25
              ###### zeit-pkg fixing starts here.
              # we're replacing plaintext js code that looks like
              # PAYLOAD_POSITION = '1234                  ' | 0
              # [...]
              # PRELUDE_POSITION = '1234                  ' | 0
              # ^-----20-chars-----^^------22-chars------^
              # ^-- grep points here
              #
              # var_* are as described above
              # shift_by seems to be safe so long as all patchelf adjustments occur
              # before any locations pointed to by hardcoded offsets
              var_skip=20
              var_select=22
              shift_by=$(expr $new_size - $orig_size)
              function fix_offset {
                # $1 = name of variable to adjust
                location=$(grep -obUam1 "$1" $agent | cut -d: -f1)
                location=$(expr $location + $var_skip)
                value=$(dd if=$agent iflag=count_bytes,skip_bytes skip=$location \
                 bs=1 count=$var_select status=none)
                value=$(expr $shift_by + $value)
                echo -n $value | dd of=$agent bs=1 seek=$location conv=notrunc
              }
              fix_offset PAYLOAD_POSITION
              fix_offset PRELUDE_POSITION
            '';
          };
        };
      in
        addPlugins editor [copilot-plugin];
  in {
    inherit (inputs.flake-firefox-nightly.packages.${prev.system}) firefox-nightly-bin;
    inherit (inputs.nil.packages.${prev.system}) nil;
    inherit (inputs.prism-launcher.packages.${prev.system}) prismlauncher;
    inherit (inputs.nixpkgs-old.legacyPackages.${prev.system}) gnome webkitgtk webkitgtk_4_1 webkitgtk_5_0;

    draconis = inputs.draconis.defaultPackage.${prev.system};
    riff = inputs.riff.defaultPackage.${prev.system};
    glrnvim = inputs.glrnvim.defaultPackage.${prev.system};
    tre = inputs.tre.defaultPackage.${prev.system};
    nix-snow = inputs.nix-snow.defaultPackage.${prev.system};
    nurl = inputs.nurl.packages.${prev.system}.default;

    catppuccin-cursors = final.callPackage ./catppuccin-cursors.nix {};
    catppuccin-folders = final.callPackage ./catppuccin-folders.nix {};
    httpie-desktop = final.callPackage ./httpie-desktop.nix {};
    jetbrains-fleet = final.callPackage ./fleet.nix {};
    python-material-color-utilities = final.callPackage ./material-color-utilities.nix {};
    revolt = final.callPackage ./revolt.nix {};
    nushell-pkg = final.callPackage ./nushell-pkg.nix {};

    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      patchPhase = ''
        substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
      '';
    });

    bluez = prev.bluez.overrideAttrs (_: {
      doCheck = false;
    });

    ell = prev.ell.overrideAttrs (_: {
      doCheck = false;
    });

    gssdp = prev.gssdp.overrideAttrs (_: {
      doCheck = false;
    });

    libadwaita = prev.libadwaita.overrideAttrs (_: {
      doCheck = false;
    });

    libhandy = prev.libhandy.overrideAttrs (_: {
      doCheck = false;
    });

    libpulseaudio = prev.libpulseaudio.overrideAttrs (_: {
      doCheck = false;
    });

    libsecret = prev.libsecret.overrideAttrs (_: {
      doCheck = false;
    });

    openssh = prev.openssh.overrideAttrs (_: {
      doCheck = false;
    });

    zscroll = prev.zscroll.overrideAttrs (_: {
      inherit (sources.zscroll) src pname version;
    });

    copilot-vim = prev.vimPlugins.copilot-vim.overrideAttrs (_: {
      inherit (sources.copilot-vim) src pname version;
    });

    codeium-vim = prev.vimUtils.buildVimPlugin {
      inherit (sources.codeium-vim) src pname version;
    };

    nvim-cokeline = prev.vimUtils.buildVimPlugin {
      inherit (sources.nvim-cokeline) src pname version;
    };

    nvim-nu = prev.vimUtils.buildVimPlugin {
      inherit (sources.nvim-nu) src pname version;
    };

    move-nvim = prev.vimUtils.buildVimPlugin {
      inherit (sources.move-nvim) src pname version;
    };

    alternate-toggler-nvim = prev.vimUtils.buildVimPlugin {
      inherit (sources.alternate-toggler-nvim) src pname version;
    };

    python310Packages =
      inputs.nixpkgs-old.legacyPackages.${prev.system}.python310Packages
      // {
        afdko = inputs.nixpkgs-old.legacyPackages.${prev.system}.python310Packages.afdko.overrideAttrs (oldAttrs: {
          doCheck = false;
        });
      };

    spotifywm-fixed = prev.spotifywm.overrideAttrs (_: {
      src = prev.fetchFromGitHub {
        owner = "dasJ";
        repo = "spotifywm";
        rev = "8624f539549973c124ed18753881045968881745";
        sha256 = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
      };
    });

    starfetch =
      prev.starfetch.overrideAttrs
      (o: {
        version = "0.0.4";

        src = prev.fetchFromGitHub {
          owner = "Haruno19";
          repo = "starfetch";
          rev = "0.0.4";
          sha256 = "sha256-I2M/FlLRkGtD2+GcK1l5+vFsb5tCb4T3UJTPxRx68Ww=";
        };
      });

    mpv-unwrapped =
      prev.mpv-unwrapped.overrideAttrs
      (o: {
        src = prev.fetchFromGitHub {
          owner = "mpv-player";
          repo = "mpv";
          rev = "48ad2278c7a1fc2a9f5520371188911ef044b32c";
          sha256 = "sha256-6qbv34ysNQbI/zff6rAnVW4z6yfm2t/XL/PF7D/tjv4=";
        };
      });

    discord-plugged =
      inputs.replugged.packages.${prev.system}.discord-plugged.override
      {
        discord-canary = prev.discord-canary.override {
          nss = final.nss_latest;
          openasar = final.callPackage ./openasar.nix {inherit (sources.openasar) src pname version;};
          withOpenASAR = true;
        };
      };

    firefox-addons =
      prev.callPackages
      ./firefox-addons
      {};

    sddm-dexy-theme =
      inputs.nixpkgs-old.legacyPackages.${prev.system}.plasma5Packages.callPackage
      ./sddm-theme.nix
      {inherit sources;};

    inherit
      (inputs.nixpkgs-old.legacyPackages.${prev.system}.qt5)
      qtwebengine
      ;
  })

  inputs.fenix.overlays.default
]
