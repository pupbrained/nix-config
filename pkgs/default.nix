inputs:
inputs.nixpkgs.lib.composeManyExtensions [
  (final: prev: let
    sources = prev.callPackage ./_sources/generated.nix {};
  in {
    alternate-toggler-nvim = prev.vimUtils.buildVimPlugin {
      inherit (sources.alternate-toggler-nvim) src pname version;
    };

    copilot-vim = prev.vimPlugins.copilot-vim.overrideAttrs (_: {
      inherit (sources.copilot-vim) src pname version;
    });

    move-nvim = prev.vimUtils.buildVimPlugin {
      inherit (sources.move-nvim) src pname version;
    };

    nvim-cokeline = prev.vimUtils.buildVimPlugin {
      inherit (sources.nvim-cokeline) src pname version;
    };
  })
]
