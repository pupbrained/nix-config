let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

let-env PATH = ($env.PATH | append "/home/marshall/.local/bin:/home/marshall/.cargo/bin:/home/marshall/go/bin:/marshall/.npm-packages/bin:/run/wrappers/bin:/home/marshall/.nix-profile/bin:/etc/profiles/per-user/marshall/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin")

let-env STARSHIP_SHELL = "nu"
let width = ((term size).columns)

def create_left_prompt [] {
    /home/marshall/.nix-profile/bin/starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

def gcap [commitMsg] {
  git add .; git commit -m $commitMsg; git push
}

let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = ""

let-env PROMPT_INDICATOR = ""
let-env PROMPT_INDICATOR_VI_INSERT = ": "
let-env PROMPT_INDICATOR_VI_NORMAL = "〉"
let-env PROMPT_MULTILINE_INDICATOR = "::: "

let-env EDITOR = "vi"
