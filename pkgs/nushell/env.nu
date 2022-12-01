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

let-env STARSHIP_SHELL = "nu"
let width = ((term size).columns)

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = ""

let-env PROMPT_INDICATOR = ""
let-env PROMPT_INDICATOR_VI_INSERT = ": "
let-env PROMPT_INDICATOR_VI_NORMAL = "〉"
let-env PROMPT_MULTILINE_INDICATOR = "::: "

let-env PATH = ($env.PATH | append "/home/marshall/.local/bin:/home/marshall/.cargo/bin:/home/marshall/go/bin:/marshall/.npm-packages/bin")
