let base00 = "#1e1e2e" # Default Background
let base01 = "#313244" # Lighter Background (Used for status bars, line number and folding marks)
let base02 = "#45475a" # Selection Background
let base03 = "#585b70" # Comments, Invisibles, Line Highlighting
let base04 = "#9399b2" # Dark Foreground (Used for status bars)
let base05 = "#a6adc8" # Default Foreground, Caret, Delimiters, Operators
let base06 = "#bac2de" # Light Foreground (Not often used)
let base07 = "#cdd6f4" # Light Background (Not often used)
let base08 = "#f38ba8" # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
let base09 = "#fab387" # Integers, Boolean, Constants, XML Attributes, Markup Link Url
let base0a = "#f9e2af" # Classes, Markup Bold, Search Text Background
let base0b = "#a6e3a1" # Strings, Inherited Class, Markup Code, Diff Inserted
let base0c = "#94e2d5" # Support, Regular Expressions, Escape Characters, Markup Quotes
let base0d = "#74c7ec" # Functions, Methods, Attribute IDs, Headings
let base0e = "#b4befe" # Keywords, Storage, Selector, Markup Italic, Diff Changed
let base0f = "#f2cdcd" # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>

let catppuccin_theme = {
    separator: $base03
    leading_trailing_space_bg: $base04
    header: $base0b
    date: $base0e
    filesize: $base0d
    row_index: $base0c
    bool: $base08
    int: $base0b
    duration: $base08
    range: $base08
    float: $base08
    string: $base04
    nothing: $base08
    binary: $base08
    cellpath: $base08
    hints: dark_gray

    shape_garbage: { fg: $base07 bg: $base08 attr: b}
    shape_bool: $base0d
    shape_int: { fg: $base0e attr: b}
    shape_float: { fg: $base0e attr: b}
    shape_range: { fg: $base0a attr: b}
    shape_internalcall: { fg: $base0c attr: b}
    shape_external: $base0c
    shape_externalarg: { fg: $base0b attr: b}
    shape_literal: $base0d
    shape_operator: $base0a
    shape_signature: { fg: $base0b attr: b}
    shape_string: $base0b
    shape_filepath: $base0d
    shape_globpattern: { fg: $base0d attr: b}
    shape_variable: $base0e
    shape_flag: { fg: $base0d attr: b}
    shape_custom: {attr: b}
}

let-env config = {
  show_banner: false
  buffer_editor: "nvim"
  color_config: $catppuccin_theme
  use_grid_icons: true
  use_ansi_coloring: true
  footer_mode: always
  cursor_shape: {
    emacs: line
    vi_insert: block
    vi_normal: underscore
  }
  ls: {
    use_ls_colors: true
  }
  filesize: {
    metric: true
  }
  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
    external: {
      enable: true
      max_results: 100
      completer: {|spans|
        carapace $spans.0 nushell $spans | from json
      }
    }
  }
  hooks: {
    pre_prompt: [{
      code: "
        let direnv = (direnv export json | from json)
        let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
        $direnv | load-env
      "
    }]
  }
}

alias cat = bat
alias ga = git add
alias gap = git add -p
alias gc = git commit
alias gp = git push
alias gd = git diff
alias gs = git status
alias lg = lazygit

let-env config = ($env | default {} config).config
let-env config = ($env.config | default {} hooks)
let-env config = ($env.config | update hooks ($env.config.hooks | default {} env_change))
let-env config = ($env.config | update hooks.env_change ($env.config.hooks.env_change | default [] PWD))
let-env config = ($env.config | update hooks.env_change.PWD ($env.config.hooks.env_change.PWD | append {|_, dir|
  zoxide add -- $dir
}))

def-env __zoxide_z [...rest:string] {
  let arg0 = ($rest | append '~').0
  let path = if (($rest | length) <= 1) and ($arg0 == '-' or ($arg0 | path expand | path type) == dir) {
    $arg0
  } else {
    (zoxide query --exclude $env.PWD -- $rest | str trim -r -c "\n")
  }
  cd $path
}

def-env __zoxide_zi  [...rest:string] {
  cd $'(zoxide query -i -- $rest | str trim -r -c "\n")'
}

alias cd = __zoxide_z
alias cdi = __zoxide_zi

#/home/marshall/.nix-profile/bin/draconis
starfetch
