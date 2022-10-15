{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      pkgs.copilot-vim
      pkgs.nvim-cokeline
      pkgs.nvim-staline

      cmp_luasnip
      cmp-path
      cmp-buffer
      cmp-nvim-lsp
      catppuccin-nvim
      comment-nvim
      dashboard-nvim
      FTerm-nvim
      gitsigns-nvim
      indent-blankline-nvim
      lazygit-nvim
      lightspeed-nvim
      lspkind-nvim
      luasnip
      markdown-preview-nvim
      null-ls-nvim
      nvim-autopairs
      nvim-cmp
      nvim-lspconfig
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      nvim-tree-lua
      nvim-web-devicons
      presence-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      trouble-nvim
      which-key-nvim
      vim-cool
      vim-smoothie
    ];

    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./config.lua}
      EOF
    '';
  };
}
