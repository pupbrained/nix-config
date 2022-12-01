let-env config = {
  show_banner: false
  hooks: {
    pre_prompt: [{
      code: "
        let direnv = (/run/current-system/sw/bin/direnv export json | from json)
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
  /run/current-system/sw/bin/zoxide add -- $dir
}))

def-env __zoxide_z [...rest:string] {
  let arg0 = ($rest | append '~').0
  let path = if (($rest | length) <= 1) && ($arg0 == '-' || ($arg0 | path expand | path type) == dir) {
    $arg0
  } else {
    (/run/current-system/sw/bin/zoxide query --exclude $env.PWD -- $rest | str trim -r -c "\n")
  }
  cd $path
}

def-env __zoxide_zi  [...rest:string] {
  cd $'(/run/current-system/sw/bin/zoxide query -i -- $rest | str trim -r -c "\n")'
}

alias cd = __zoxide_z
alias cdi = __zoxide_zi

/home/marshall/.nix-profile/bin/draconis
